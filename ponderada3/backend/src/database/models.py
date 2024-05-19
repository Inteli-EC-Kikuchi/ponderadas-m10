from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import Session
from database.database import Base
from passlib.context import CryptContext

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    hashed_password = Column(String)

    def authenticate_user(self, password: str):
        pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
        return pwd_context.verify(password, self.hashed_password)
