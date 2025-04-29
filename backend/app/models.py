from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, Enum, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base
import enum
from datetime import datetime
import uuid

class PlayerPosition(enum.Enum):
    setter = "setter"
    outside = "outside"
    opposite = "opposite"
    middle = "middle"
    libero = "libero"

class PlayerStatus(enum.Enum):
    active = "active"
    inactive = "inactive"
    injured = "injured"
    suspended = "suspended"

class Player(Base):
    __tablename__ = "players"

    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    number = Column(Integer, nullable=False)
    position = Column(Enum(PlayerPosition), nullable=False)
    status = Column(Enum(PlayerStatus), nullable=False, default=PlayerStatus.active)
    height = Column(Float, nullable=False)
    weight = Column(Float, nullable=False)
    photo_url = Column(String, nullable=True)
    birth_date = Column(DateTime, nullable=False)
    nationality = Column(String, nullable=False)
    is_present = Column(Boolean, default=True)

    # Habilidades (0-5)
    attack = Column(Integer, nullable=False)
    defense = Column(Integer, nullable=False)
    setting = Column(Integer, nullable=False)
    reception = Column(Integer, nullable=False)
    serve = Column(Integer, nullable=False)
    speed = Column(Integer, nullable=True)
    communication = Column(Integer, nullable=True)

    # Contato
    phone = Column(String, nullable=True)
    email = Column(String, nullable=True)

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)
    is_admin = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow) 