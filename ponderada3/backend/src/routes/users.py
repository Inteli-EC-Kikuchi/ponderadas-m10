from passlib.context import CryptContext
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel
from database.models import User
from database.database import get_db
import logging

router = APIRouter()
logger = logging.getLogger(__name__)

class UserCreate(BaseModel):
    name: str
    password: str

class UserOut(BaseModel):
    id: int
    name: str

class UserLogin(BaseModel):
    name: str
    password: str

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@router.post("/", response_model=UserOut)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.name == user.name).first()
    if db_user:
        logger.warning(f"Attempt to register already existing user: {user.name}")
        raise HTTPException(status_code=400, detail="Username already registered")
    
    hashed_password = pwd_context.hash(user.password)
    db_user = User(name=user.name, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    logger.info(f"User registered: {user.name}")
    return db_user


@router.get("/", response_model=list[UserOut])
def read_users(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    users = db.query(User).offset(skip).limit(limit).all()
    return users

@router.post("/login")
def login_user(user_login: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.name == user_login.name).first()
    if not user or not user.authenticate_user(user_login.password):
        logger.warning(f"Failed login attempt for user: {user_login.name}")
        raise HTTPException(status_code=401, detail="Incorrect username or password")
    logger.info(f"User logged in: {user_login.name}")
    return {"message": "Login successful"}