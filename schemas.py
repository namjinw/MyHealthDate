from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


def today() -> str:
    return datetime.now().strftime("%Y-%m-%d")


class SigninRequest(BaseModel):
    mberId: str
    mberPassword: str


class ProfileUpdateRequest(BaseModel):
    mberNm: Optional[str] = None
    sexdstn: Optional[str] = None       # M or F
    height: Optional[float] = None
    weight: Optional[float] = None
    brthdy: Optional[str] = None        # YYYY-MM-DD
    stepTarget: Optional[int] = None
    waterTarget: Optional[int] = None


class StepInsertRequest(BaseModel):
    stepCount: int
    date: Optional[str] = None          # YYYY-MM-DD, 없으면 서버 오늘 날짜


class WaterInsertRequest(BaseModel):
    water: int                           # 100 or 250
    date: Optional[str] = None


class AlarmInsertRequest(BaseModel):
    alarmKndCd: Optional[str] = None    # F, W, E
    hour: int
    mnt: int
    date: Optional[str] = None