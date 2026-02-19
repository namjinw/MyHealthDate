from fastapi import FastAPI, Depends, HTTPException, Request, File, UploadFile, Form, Path
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from jose import jwt
from datetime import datetime, timedelta
from typing import Optional
import os
import uuid
import random

import models
import schemas
from database import SessionLocal, engine, Base, get_db

# 테이블 생성
Base.metadata.create_all(bind=engine)

app = FastAPI(title="MY Health DATA API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 파일 업로드 디렉토리
UPLOAD_DIR = "static/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)
app.mount("/static", StaticFiles(directory="static"), name="static")

SECRET_KEY = "MY_HEALTH_DATA_SECRET_2025"
ALGORITHM = "HS256"

FOOD_IMAGE_PATH_PREFIX = "/static/uploads/"


# ─── Utility ────────────────────────────────────────────────────────────────

def create_token(mber_id: str) -> str:
    payload = {
        "mberId": mber_id,
        "exp": datetime.utcnow() + timedelta(hours=24)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(request: Request, db: Session = Depends(get_db)) -> models.User:
    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Unauthorized")
    token = auth_header.split(" ", 1)[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        mber_id = payload.get("mberId")
        user = db.query(models.User).filter(models.User.mber_id == mber_id).first()
        if not user:
            raise HTTPException(status_code=401, detail="Unauthorized")
        return user
    except Exception:
        raise HTTPException(status_code=401, detail="Unauthorized")


def ok(extra: dict = None) -> dict:
    base = {"STATUS_MSG": "success", "STATUS_CD": "M000", "host": "localhost", "success": True}
    if extra:
        base.update(extra)
    return base


def err(msg: str, cd: str = "E001") -> JSONResponse:
    return JSONResponse(
        status_code=200,
        content={"STATUS_MSG": msg, "STATUS_CD": cd, "host": "localhost", "success": False}
    )


def today() -> str:
    return datetime.now().strftime("%Y-%m-%d")


# ─── 100. Authentication ─────────────────────────────────────────────────────

@app.post("/api/authenticate/signup", tags=["Authentication"])
def signup(
    mberId: str = Form(...),
    mberPassword: str = Form(...),
    mberNm: str = Form(...),
    db: Session = Depends(get_db)
):
    if len(mberId) < 4 or " " in mberId:
        return err("아이디는 4자 이상이며 공백을 포함할 수 없습니다.", "E002")
    if len(mberPassword) < 4:
        return err("비밀번호는 4자 이상이어야 합니다.", "E002")

    existing = db.query(models.User).filter(models.User.mber_id == mberId).first()
    if existing:
        return err("이미 존재하는 아이디입니다.", "E002")

    user = models.User(mber_id=mberId, mber_password=mberPassword, mber_nm=mberNm)
    db.add(user)
    db.commit()
    db.refresh(user)

    tkn = create_token(mberId)
    return ok({"tkn": tkn, "mberId": mberId, "mberNm": mberNm})


@app.post("/api/authenticate/signin", tags=["Authentication"])
def signin(req: schemas.SigninRequest, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(
        models.User.mber_id == req.mberId,
        models.User.mber_password == req.mberPassword
    ).first()
    if not user:
        return err("아이디 또는 비밀번호가 올바르지 않습니다.", "E003")

    tkn = create_token(user.mber_id)
    return ok({"tkn": tkn, "mberId": user.mber_id, "mberNm": user.mber_nm})


@app.get("/api/authenticate/signout", tags=["Authentication"])
def signout(user: models.User = Depends(get_current_user)):
    # 새 토큰 발급 → 기존 토큰 무효화 개념
    new_tkn = create_token(user.mber_id)
    return ok({"tkn": new_tkn})


# ─── 200. Profile & Target ───────────────────────────────────────────────────

@app.get("/api/profile", tags=["Profile"])
def get_profile(user: models.User = Depends(get_current_user)):
    return ok({
        "mberId": user.mber_id,
        "mberNm": user.mber_nm,
        "sexdstn": user.sexdstn,
        "height": user.height,
        "weight": user.weight,
        "brthdy": user.brthdy,
        "stepTarget": user.step_target,
        "waterTarget": user.water_target,
    })


@app.put("/api/profile", tags=["Profile"])
def update_profile(
    req: schemas.ProfileUpdateRequest,
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if req.mberNm is not None:
        user.mber_nm = req.mberNm
    if req.sexdstn is not None:
        user.sexdstn = req.sexdstn
    if req.height is not None:
        user.height = req.height
    if req.weight is not None:
        user.weight = req.weight
    if req.brthdy is not None:
        user.brthdy = req.brthdy
    if req.stepTarget is not None:
        user.step_target = req.stepTarget
    if req.waterTarget is not None:
        user.water_target = req.waterTarget

    db.commit()
    return ok()


# ─── 300. Home ───────────────────────────────────────────────────────────────

@app.get("/api/home", tags=["Home"])
def home(user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    td = today()

    # 오늘 걸음 합계
    steps_today = db.query(models.Step).filter(
        models.Step.mber_id == user.mber_id,
        models.Step.rcord_dt == td
    ).all()
    total_steps = sum(s.step_cnt for s in steps_today)

    # 오늘 심박수 목록
    hearts = db.query(models.HeartRate).filter(
        models.HeartRate.mber_id == user.mber_id,
        models.HeartRate.rcord_dt == td
    ).all()
    heart_list = [{"heartUid": h.heart_uid, "heartRate": h.heart_rate,
                   "rcordDt": h.rcord_dt, "mberId": h.mber_id,
                   "registDt": h.regist_dt.strftime("%Y-%m-%d %H:%M:%S")} for h in hearts]
    last_heart = hearts[-1].heart_rate if hearts else 0

    # 오늘 음식 목록
    foods = db.query(models.Food).filter(
        models.Food.mber_id == user.mber_id,
        models.Food.rcord_dt == td
    ).all()
    food_list = [{"foodUid": f.food_uid, "fileNm": f.file_nm, "fileSize": f.file_size,
                  "maskNm": f.mask_nm, "rcordDt": f.rcord_dt, "foodKndCd": f.food_knd_cd,
                  "mberId": f.mber_id,
                  "registDt": f.regist_dt.strftime("%Y-%m-%d %H:%M:%S")} for f in foods]

    # 오늘 수분 합계
    waters_today = db.query(models.Water).filter(
        models.Water.mber_id == user.mber_id,
        models.Water.rcord_dt == td
    ).all()
    total_water = sum(w.water_cnt for w in waters_today)

    return ok({
        "mberId": user.mber_id,
        "mberNm": user.mber_nm,
        "sexdstn": user.sexdstn,
        "height": user.height,
        "weight": user.weight,
        "brthdy": user.brthdy,
        "stepTarget": user.step_target,
        "waterTarget": user.water_target,
        "todayFoodList": food_list,
        "food_image_path_prefix": FOOD_IMAGE_PATH_PREFIX,
        "stepCount": total_steps,
        "heartRateList": heart_list,
        "lastHeartRate": last_heart,
        "water": total_water,
    })


# ─── 400. Step ───────────────────────────────────────────────────────────────

@app.post("/api/step", tags=["Step"])
def insert_step(
    req: schemas.StepInsertRequest,
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    step = models.Step(mber_id=user.mber_id, step_cnt=req.stepCount, rcord_dt=today())
    db.add(step)
    db.commit()
    return ok()


@app.get("/api/step", tags=["Step"])
def get_today_step(user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    steps = db.query(models.Step).filter(
        models.Step.mber_id == user.mber_id,
        models.Step.rcord_dt == today()
    ).all()
    total = sum(s.step_cnt for s in steps)
    return ok({"step": total})


@app.get("/api/step/{date}", tags=["Step"])
def get_step_list(
    date: str = Path(...),
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    steps = db.query(models.Step).filter(
        models.Step.mber_id == user.mber_id,
        models.Step.rcord_dt == date
    ).all()
    lst = [{"stepUid": s.step_uid, "rcordDt": s.rcord_dt, "mberId": s.mber_id,
            "registDt": s.regist_dt.strftime("%Y-%m-%d %H:%M:%S"), "stepCnt": s.step_cnt}
           for s in steps]
    return ok({"list": lst})


# ─── 500. Heart Rate ─────────────────────────────────────────────────────────

@app.post("/api/heart", tags=["Heart Rate"])
def measure_heart(user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    rate = random.randint(0, 200)
    heart = models.HeartRate(mber_id=user.mber_id, heart_rate=rate, rcord_dt=today())
    db.add(heart)
    db.commit()
    db.refresh(heart)
    return ok({"heartRate": rate})


@app.get("/api/heart", tags=["Heart Rate"])
def get_today_heart(user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    hearts = db.query(models.HeartRate).filter(
        models.HeartRate.mber_id == user.mber_id,
        models.HeartRate.rcord_dt == today()
    ).order_by(models.HeartRate.regist_dt).all()
    lst = [{"heartUid": h.heart_uid, "heartRate": h.heart_rate, "rcordDt": h.rcord_dt,
            "mberId": h.mber_id, "registDt": h.regist_dt.strftime("%Y-%m-%d %H:%M:%S")}
           for h in hearts]
    last = hearts[-1].heart_rate if hearts else 0
    return ok({"list": lst, "lastHeartRate": last})


@app.get("/api/heart/{date}", tags=["Heart Rate"])
def get_heart_list(
    date: str = Path(...),
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    hearts = db.query(models.HeartRate).filter(
        models.HeartRate.mber_id == user.mber_id,
        models.HeartRate.rcord_dt == date
    ).order_by(models.HeartRate.regist_dt).all()
    lst = [{"heartUid": h.heart_uid, "heartRate": h.heart_rate, "rcordDt": h.rcord_dt,
            "mberId": h.mber_id, "registDt": h.regist_dt.strftime("%Y-%m-%d %H:%M:%S")}
           for h in hearts]
    return ok({"list": lst})


# ─── 600. Food ───────────────────────────────────────────────────────────────

@app.post("/api/food", tags=["Food"])
async def insert_food(
    foodKndCd: str = Form(...),
    file: Optional[UploadFile] = File(None),
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    file_nm = None
    mask_nm = None
    file_size = None

    if file and file.filename:
        ext = os.path.splitext(file.filename)[1]
        mask = f"{uuid.uuid4().hex}{ext}"
        filepath = os.path.join(UPLOAD_DIR, mask)
        content = await file.read()
        with open(filepath, "wb") as f:
            f.write(content)
        file_nm = file.filename
        mask_nm = mask
        file_size = str(len(content))

    food = models.Food(
        mber_id=user.mber_id,
        food_knd_cd=foodKndCd,
        file_nm=file_nm,
        mask_nm=mask_nm,
        file_size=file_size,
        rcord_dt=today()
    )
    db.add(food)
    db.commit()
    return ok()


@app.get("/api/food/{date}", tags=["Food"])
def get_food_list(
    date: str = Path(...),
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    foods = db.query(models.Food).filter(
        models.Food.mber_id == user.mber_id,
        models.Food.rcord_dt == date
    ).order_by(models.Food.regist_dt).all()
    lst = [{"foodUid": f.food_uid, "fileNm": f.file_nm, "fileSize": f.file_size,
            "maskNm": f.mask_nm, "rcordDt": f.rcord_dt, "foodKndCd": f.food_knd_cd,
            "mberId": f.mber_id, "registDt": f.regist_dt.strftime("%Y-%m-%d %H:%M:%S")}
           for f in foods]
    return ok({"list": lst, "food_image_path_prefix": FOOD_IMAGE_PATH_PREFIX})


@app.delete("/api/food/{foodUid}", tags=["Food"])
def delete_food(
    foodUid: int = Path(...),
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    food = db.query(models.Food).filter(
        models.Food.food_uid == foodUid,
        models.Food.mber_id == user.mber_id
    ).first()
    if not food:
        return err("해당 음식 데이터를 찾을 수 없습니다.", "E004")

    # 파일도 삭제
    if food.mask_nm:
        path = os.path.join(UPLOAD_DIR, food.mask_nm)
        if os.path.exists(path):
            os.remove(path)

    db.delete(food)
    db.commit()
    return ok()


# ─── 700. Water ──────────────────────────────────────────────────────────────

@app.post("/api/water", tags=["Water"])
def insert_water(
    req: schemas.WaterInsertRequest,
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if req.water not in (100, 250):
        return err("water 값은 100 또는 250이어야 합니다.", "E002")

    water = models.Water(mber_id=user.mber_id, water_cnt=req.water, rcord_dt=today())
    db.add(water)
    db.commit()
    return ok()


@app.get("/api/water", tags=["Water"])
def get_today_water(user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    waters = db.query(models.Water).filter(
        models.Water.mber_id == user.mber_id,
        models.Water.rcord_dt == today()
    ).all()
    total = sum(w.water_cnt for w in waters)
    return ok({"water": total})


@app.get("/api/water/{date}", tags=["Water"])
def get_water_list(
    date: str = Path(...),
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    waters = db.query(models.Water).filter(
        models.Water.mber_id == user.mber_id,
        models.Water.rcord_dt == date
    ).order_by(models.Water.regist_dt).all()
    lst = [{"waterUid": w.water_uid, "rcordDt": w.rcord_dt, "mberId": w.mber_id,
            "registDt": w.regist_dt.strftime("%Y-%m-%d %H:%M:%S"), "waterCnt": w.water_cnt}
           for w in waters]
    return ok({"list": lst})


# ─── 800. Alarm ──────────────────────────────────────────────────────────────

@app.post("/api/alarm", tags=["Alarm"])
def insert_alarm(
    req: schemas.AlarmInsertRequest,
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    alarm = models.Alarm(
        mber_id=user.mber_id,
        alarm_knd_cd=req.alarmKndCd,
        hour=req.hour,
        mnt=req.mnt,
        use_yn="Y"
    )
    db.add(alarm)
    db.commit()
    return ok()


@app.get("/api/alarm", tags=["Alarm"])
def get_alarm_list(user: models.User = Depends(get_current_user), db: Session = Depends(get_db)):
    alarms = db.query(models.Alarm).filter(
        models.Alarm.mber_id == user.mber_id
    ).order_by(models.Alarm.regist_dt).all()
    lst = [{"alarmUid": a.alarm_uid, "alarmKndCd": a.alarm_knd_cd,
            "hour": a.hour, "mnt": a.mnt, "mberId": a.mber_id,
            "useYn": a.use_yn,
            "registDt": a.regist_dt.strftime("%Y-%m-%d %H:%M:%S")}
           for a in alarms]
    return ok({"list": lst})


@app.put("/api/alarm/{alarmUid}/{useYN}", tags=["Alarm"])
def modify_alarm_usage(
    alarmUid: int = Path(...),
    useYN: str = Path(...),
    user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if useYN not in ("Y", "N"):
        return err("useYN 값은 Y 또는 N이어야 합니다.", "E002")

    alarm = db.query(models.Alarm).filter(
        models.Alarm.alarm_uid == alarmUid,
        models.Alarm.mber_id == user.mber_id
    ).first()
    if not alarm:
        return err("해당 알람을 찾을 수 없습니다.", "E004")

    alarm.use_yn = useYN
    db.commit()
    return ok()


# ─── Root ────────────────────────────────────────────────────────────────────

@app.get("/", tags=["Root"])
def root():
    return {"message": "MY Health DATA API", "version": "1.0.0", "docs": "/docs"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)