from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from typing import List
import uuid
from datetime import timedelta
from jose import JWTError, jwt

from . import models, schemas
from .database import engine, get_db
from .utils.team_drawer import draw_teams
from .utils.auth import (
    verify_password,
    get_password_hash,
    create_access_token,
    oauth2_scheme,
    ACCESS_TOKEN_EXPIRE_MINUTES,
    SECRET_KEY,
    ALGORITHM
)

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Voleizaga API")

# Configuração CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:8000", "http://127.0.0.1:3000", "http://127.0.0.1:8000"],  # Lista de origens permitidas
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Bem-vindo à API do Voleizaga!"}

@app.get("/api/players", response_model=List[schemas.Player])
def get_players(db: Session = Depends(get_db)):
    players = db.query(models.Player).all()
    return players

@app.get("/api/players/{player_id}", response_model=schemas.Player)
def get_player(player_id: str, db: Session = Depends(get_db)):
    player = db.query(models.Player).filter(models.Player.id == player_id).first()
    if player is None:
        raise HTTPException(status_code=404, detail="Jogador não encontrado")
    return player

@app.post("/api/players", response_model=schemas.Player, status_code=status.HTTP_201_CREATED)
def create_player(player: schemas.PlayerCreate, db: Session = Depends(get_db)):
    db_player = models.Player(**player.dict(), id=str(uuid.uuid4()))
    db.add(db_player)
    db.commit()
    db.refresh(db_player)
    return db_player

@app.put("/api/players/{player_id}", response_model=schemas.Player)
def update_player(player_id: str, player: schemas.PlayerUpdate, db: Session = Depends(get_db)):
    db_player = db.query(models.Player).filter(models.Player.id == player_id).first()
    if db_player is None:
        raise HTTPException(status_code=404, detail="Jogador não encontrado")
    
    update_data = player.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_player, key, value)
    
    db.commit()
    db.refresh(db_player)
    return db_player

@app.delete("/api/players/{player_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_player(player_id: str, db: Session = Depends(get_db)):
    db_player = db.query(models.Player).filter(models.Player.id == player_id).first()
    if db_player is None:
        raise HTTPException(status_code=404, detail="Jogador não encontrado")
    
    db.delete(db_player)
    db.commit()
    return {"ok": True}

@app.post("/api/teams/draw", response_model=schemas.TeamDrawResponse)
def draw_teams_endpoint(draw_request: schemas.TeamDraw, db: Session = Depends(get_db)):
    # Buscar jogadores do banco
    players = db.query(models.Player).filter(
        models.Player.id.in_(draw_request.player_ids)
    ).all()
    
    if len(players) != len(draw_request.player_ids):
        raise HTTPException(
            status_code=400,
            detail="Um ou mais jogadores não foram encontrados"
        )
    
    # Realizar o sorteio
    result = draw_teams(players, draw_request.number_of_teams)
    return result

@app.post("/token", response_model=schemas.Token)
def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = db.query(models.User).filter(models.User.username == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Usuário ou senha incorretos",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

@app.post("/users/", response_model=schemas.User, status_code=status.HTTP_201_CREATED)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    # Verificar se usuário já existe
    db_user = db.query(models.User).filter(
        (models.User.username == user.username) | 
        (models.User.email == user.email)
    ).first()
    if db_user:
        raise HTTPException(
            status_code=400,
            detail="Usuário ou email já cadastrado"
        )
    
    # Criar novo usuário
    hashed_password = get_password_hash(user.password)
    db_user = models.User(
        username=user.username,
        email=user.email,
        hashed_password=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# Função auxiliar para verificar usuário atual
async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> models.User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Credenciais inválidas",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = schemas.TokenData(username=username)
    except JWTError:
        raise credentials_exception
    
    user = db.query(models.User).filter(models.User.username == token_data.username).first()
    if user is None:
        raise credentials_exception
    return user

# Exemplo de rota protegida
@app.get("/users/me/", response_model=schemas.User)
async def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user 