"""
MY Health DATA - Database Initialization Script
app.db를 생성하고 샘플 데이터를 삽입합니다.
"""

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from database import engine, SessionLocal, Base
import models
from datetime import datetime, timedelta
import random


def init_db():
    print("=" * 60)
    print("MY Health DATA - Database Initialization")
    print("=" * 60)

    # 테이블 생성
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    print("✓ 테이블 생성 완료")

    db = SessionLocal()
    try:
        # ── 샘플 사용자 ──────────────────────────────────────────
        users = [
            models.User(mber_id="user", mber_password="1234", mber_nm="Mobile Man",
                        sexdstn="M", height=175.0, weight=70.0, brthdy="1990-01-01",
                        step_target=10000, water_target=2000),
            models.User(mber_id="user01", mber_password="1234", mber_nm="홍길동",
                        sexdstn="M", height=182.5, weight=80.5, brthdy="1986-09-30",
                        step_target=5000, water_target=2000),
            models.User(mber_id="user02", mber_password="1234", mber_nm="김철수",
                        sexdstn="M", height=170.0, weight=65.0, brthdy="1995-03-15",
                        step_target=8000, water_target=1500),
            models.User(mber_id="user03", mber_password="1234", mber_nm="이영희",
                        sexdstn="F", height=162.0, weight=52.0, brthdy="1998-07-22",
                        step_target=7000, water_target=1800),
        ]
        db.add_all(users)
        db.commit()
        print(f"✓ 사용자 {len(users)}명 생성 완료")

        # ── 샘플 걸음 수 ─────────────────────────────────────────
        today_str = datetime.now().strftime("%Y-%m-%d")
        yesterday_str = (datetime.now() - timedelta(days=1)).strftime("%Y-%m-%d")

        steps = [
            models.Step(mber_id="user01", step_cnt=1200, rcord_dt=today_str),
            models.Step(mber_id="user01", step_cnt=800, rcord_dt=today_str),
            models.Step(mber_id="user01", step_cnt=578, rcord_dt=today_str),
            models.Step(mber_id="user01", step_cnt=3500, rcord_dt=yesterday_str),
            models.Step(mber_id="user", step_cnt=500, rcord_dt=today_str),
        ]
        db.add_all(steps)
        db.commit()
        print(f"✓ 걸음 수 {len(steps)}건 생성 완료")

        # ── 샘플 심박수 ──────────────────────────────────────────
        hearts = []
        for i, rate in enumerate([72, 85, 118, 95, 78]):
            h = models.HeartRate(
                mber_id="user01",
                heart_rate=rate,
                rcord_dt=today_str,
                regist_dt=datetime.now() - timedelta(minutes=(len([72, 85, 118, 95, 78]) - i) * 10)
            )
            hearts.append(h)
        hearts.append(models.HeartRate(mber_id="user", heart_rate=88, rcord_dt=today_str))
        db.add_all(hearts)
        db.commit()
        print(f"✓ 심박수 {len(hearts)}건 생성 완료")

        # ── 샘플 음식 ────────────────────────────────────────────
        foods = [
            models.Food(mber_id="user01", food_knd_cd="B", file_nm="breakfast.jpg",
                        mask_nm="sample_breakfast.jpg", file_size="102400", rcord_dt=today_str),
            models.Food(mber_id="user01", food_knd_cd="L", file_nm="lunch.jpg",
                        mask_nm="sample_lunch.jpg", file_size="204800", rcord_dt=today_str),
            models.Food(mber_id="user01", food_knd_cd="D", file_nm="dinner.jpg",
                        mask_nm="sample_dinner.jpg", file_size="153600", rcord_dt=today_str),
            models.Food(mber_id="user01", food_knd_cd="B", file_nm="snack.jpg",
                        mask_nm="sample_snack.jpg", file_size="81920", rcord_dt=yesterday_str),
            models.Food(mber_id="user01", food_knd_cd="L", file_nm="lunch2.jpg",
                        mask_nm="sample_lunch2.jpg", file_size="92160", rcord_dt=yesterday_str),
        ]
        db.add_all(foods)
        db.commit()
        print(f"✓ 음식 {len(foods)}건 생성 완료")

        # ── 샘플 수분 ────────────────────────────────────────────
        waters = [
            models.Water(mber_id="user01", water_cnt=250, rcord_dt=today_str),
            models.Water(mber_id="user", water_cnt=100, rcord_dt=today_str),
            models.Water(mber_id="user", water_cnt=250, rcord_dt=today_str),
        ]
        db.add_all(waters)
        db.commit()
        print(f"✓ 수분 {len(waters)}건 생성 완료")

        # ── 샘플 알람 ────────────────────────────────────────────
        alarms = [
            models.Alarm(mber_id="user01", alarm_knd_cd="F", hour=7, mnt=30, use_yn="Y"),
            models.Alarm(mber_id="user01", alarm_knd_cd="W", hour=9, mnt=0, use_yn="Y"),
            models.Alarm(mber_id="user01", alarm_knd_cd="F", hour=12, mnt=0, use_yn="N"),
            models.Alarm(mber_id="user01", alarm_knd_cd="W", hour=15, mnt=0, use_yn="Y"),
            models.Alarm(mber_id="user01", alarm_knd_cd="E", hour=22, mnt=0, use_yn="N"),
        ]
        db.add_all(alarms)
        db.commit()
        print(f"✓ 알람 {len(alarms)}건 생성 완료")

        print("\n✓ 데이터베이스 초기화 완료!")
        print("\n[ 샘플 계정 ]")
        for u in users:
            print(f"  ID: {u.mber_id}  PW: {u.mber_password}  이름: {u.mber_nm}")

    except Exception as e:
        db.rollback()
        print(f"✗ 오류 발생: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    init_db()