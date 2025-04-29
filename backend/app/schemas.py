from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime
from enum import Enum

class PlayerPosition(str, Enum):
    setter = "setter"
    outside = "outside"
    opposite = "opposite"
    middle = "middle"
    libero = "libero"

class PlayerStatus(str, Enum):
    active = "active"
    inactive = "inactive"
    injured = "injured"
    suspended = "suspended"

class PlayerBase(BaseModel):
    name: str
    number: int = Field(..., ge=0)
    position: PlayerPosition
    status: PlayerStatus
    height: float = Field(..., gt=0)
    weight: float = Field(..., gt=0)
    photo_url: Optional[str] = None
    birth_date: datetime
    nationality: str
    is_present: bool = True
    
    # Habilidades
    attack: int = Field(..., ge=0, le=5)
    defense: int = Field(..., ge=0, le=5)
    setting: int = Field(..., ge=0, le=5)
    reception: int = Field(..., ge=0, le=5)
    serve: int = Field(..., ge=0, le=5)
    speed: Optional[int] = Field(None, ge=0, le=5)
    communication: Optional[int] = Field(None, ge=0, le=5)
    
    # Contato
    phone: Optional[str] = None
    email: Optional[EmailStr] = None

class PlayerCreate(PlayerBase):
    pass

class PlayerUpdate(PlayerBase):
    name: Optional[str] = None
    number: Optional[int] = None
    position: Optional[PlayerPosition] = None
    status: Optional[PlayerStatus] = None
    height: Optional[float] = None
    weight: Optional[float] = None
    birth_date: Optional[datetime] = None
    nationality: Optional[str] = None
    attack: Optional[int] = None
    defense: Optional[int] = None
    setting: Optional[int] = None
    reception: Optional[int] = None
    serve: Optional[int] = None

class Player(PlayerBase):
    id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# Schema para o sorteio de times
class TeamDraw(BaseModel):
    player_ids: list[str]
    number_of_teams: int = Field(..., ge=2, le=4)

class TeamDrawResponse(BaseModel):
    teams: list[list[Player]]
    error: Optional[str] = None

class UserBase(BaseModel):
    username: str
    email: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: str
    is_active: bool
    is_admin: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: str | None = None 