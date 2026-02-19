from sqlalchemy import Column, Integer, String, DateTime, Float, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, unique=True, nullable=False, index=True)
    mber_password = Column(String, nullable=False)
    mber_nm = Column(String, nullable=False)
    # Profile
    sexdstn = Column(String(1), nullable=True)       # M or F
    height = Column(Float, nullable=True)
    weight = Column(Float, nullable=True)
    brthdy = Column(String(10), nullable=True)       # "YYYY-MM-DD"
    step_target = Column(Integer, default=10000)
    water_target = Column(Integer, default=2000)
    created_at = Column(DateTime, default=datetime.now)

    steps = relationship("Step", back_populates="user", cascade="all, delete-orphan")
    heart_rates = relationship("HeartRate", back_populates="user", cascade="all, delete-orphan")
    foods = relationship("Food", back_populates="user", cascade="all, delete-orphan")
    waters = relationship("Water", back_populates="user", cascade="all, delete-orphan")
    alarms = relationship("Alarm", back_populates="user", cascade="all, delete-orphan")


class Step(Base):
    __tablename__ = "steps"

    step_uid = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, ForeignKey("users.mber_id"), nullable=False, index=True)
    step_cnt = Column(Integer, nullable=False)
    rcord_dt = Column(String(10), nullable=False)   # "YYYY-MM-DD"
    regist_dt = Column(DateTime, default=datetime.now)

    user = relationship("User", back_populates="steps")


class HeartRate(Base):
    __tablename__ = "heart_rates"

    heart_uid = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, ForeignKey("users.mber_id"), nullable=False, index=True)
    heart_rate = Column(Integer, nullable=False)
    rcord_dt = Column(String(10), nullable=False)
    regist_dt = Column(DateTime, default=datetime.now)

    user = relationship("User", back_populates="heart_rates")


class Food(Base):
    __tablename__ = "foods"

    food_uid = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, ForeignKey("users.mber_id"), nullable=False, index=True)
    food_knd_cd = Column(String(1), nullable=False)  # B, L, D
    file_nm = Column(String, nullable=True)
    mask_nm = Column(String, nullable=True)
    file_size = Column(String, nullable=True)
    rcord_dt = Column(String(10), nullable=False)
    regist_dt = Column(DateTime, default=datetime.now)

    user = relationship("User", back_populates="foods")


class Water(Base):
    __tablename__ = "waters"

    water_uid = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, ForeignKey("users.mber_id"), nullable=False, index=True)
    water_cnt = Column(Integer, nullable=False)      # 100 or 250
    rcord_dt = Column(String(10), nullable=False)
    regist_dt = Column(DateTime, default=datetime.now)

    user = relationship("User", back_populates="waters")


class Alarm(Base):
    __tablename__ = "alarms"

    alarm_uid = Column(Integer, primary_key=True, index=True, autoincrement=True)
    mber_id = Column(String, ForeignKey("users.mber_id"), nullable=False, index=True)
    alarm_knd_cd = Column(String(1), nullable=True)  # F, W, E
    hour = Column(Integer, nullable=False)
    mnt = Column(Integer, nullable=False)
    use_yn = Column(String(1), default="Y")
    regist_dt = Column(DateTime, default=datetime.now)

    user = relationship("User", back_populates="alarms")