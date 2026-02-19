from pydantic import BaseModel, Field
from typing import Optional, List


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


class WaterInsertRequest(BaseModel):
    water: int  # 100 or 250


class AlarmInsertRequest(BaseModel):
    alarmKndCd: Optional[str] = None   # F, W, E
    hour: int
    mnt: int