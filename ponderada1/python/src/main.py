import requests
from datetime import timedelta
from typing import Optional

from pydantic import BaseModel


from fastapi import FastAPI, Depends, Form, Request, Header
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.security import HTTPAuthorizationCredentials
from fastapi.templating import Jinja2Templates
from fastapi.responses import JSONResponse

from sqlalchemy.orm import Session

from database.database import SessionLocal, engine, Base
from database import models

from security.jwt import create_access_token, verify_jwt_token

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.mount("/static", StaticFiles(directory="templates"), name="static")

templates = Jinja2Templates(directory="templates")

SECRET_KEY = "b0e0e5b4a8f1c1e2b8d5c3a8b3b9d7e2"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

class TaskCreate(BaseModel):
    name: str
    description: str

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/")
def render_root():
    return FileResponse("templates/index.html")

@app.get("/register")
def render_register():
    return FileResponse("templates/register.html")

@app.get("/login-page")
def render_login():
    return FileResponse("templates/login.html")

@app.get("/todo")
def render_todo():
    return FileResponse("templates/todo.html")

@app.get("/tasks")
def tasks(request: Request, db: Session = Depends(get_db)):
    
    verification = verify_auth(request)

    if verification.get("error") is not None:
        return FileResponse("templates/error.html")

    db_tasks = db.query(models.Task).all()

    tasks = [{"id": task.id, "name": task.name} for task in db_tasks]
    
    return {"tasks": tasks}

@app.post("/tasks")
def create_task(request: Request, task: TaskCreate, db: Session = Depends(get_db)):
        
    verification = verify_auth(request)

    if verification.get("error") is not None:
        return FileResponse("templates/error.html")

    task = models.Task(name=task.name, description=task.description)

    db.add(task)
    db.commit()
    db.refresh(task)
    return {"message": "Task created successfully", "task": task}

@app.put("/tasks/{task_id}")
def update_task(request: Request, task_id: int, db: Session = Depends(get_db)):
        
    verification = verify_auth(request)

    if verification.get("error") is not None:
        return FileResponse("templates/error.html")

    task = db.query(models.Task).filter(models.Task.id == task_id).first()

    task.name = "Task 1 updated"
    db.commit()
    db.refresh(task)

    return {"message": f"Task {task_id} updated successfully"}

@app.delete("/tasks/{task_id}")
def delete_task(request: Request, task_id: int, db: Session = Depends(get_db)):
  
    verification = verify_auth(request)

    if verification.get("error") is not None:
        return FileResponse("templates/error.html")

    task = db.query(models.Task).filter(models.Task.id == task_id).first()

    db.delete(task)
    db.commit()

    return {"message": f"Task {task_id} deleted successfully"}

@app.get("/users")
def users(db: Session = Depends(get_db)):
    
    db_users = db.query(models.User).all()

    users = [{"id": user.id, "username": user.username} for user in db_users]
    
    return {"users": users}

@app.post("/users")
def create_user(db: Session = Depends(get_db), username: str = Form(), password: str = Form(), email: str = Form()):

    user = models.User(username=username, email=email, password=password)

    db.add(user)
    db.commit()
    db.refresh(user)

    return {"message": "User created successfully", "user": user}

@app.put("/users/{user_id}")
def update_user(user_id: int, db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.id == user_id).first()

    user.username = f"User {user_id} updated"
    db.commit()
    db.refresh(user)

    return {"message": f"User {user_id} updated successfully"}

@app.delete("/users/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.id == user_id).first()

    db.delete(user)
    db.commit()

    return {"message": f"User {user_id} deleted successfully"}

@app.post("/login")
def login(username: str = Form(), password: str = Form(), db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.username == username).first()

    if user is None or user.password != password:
        return FileResponse("templates/error.html")
    
    token_data = requests.post("http://localhost:8000/token", data={"username": username, "password": password}).json()

    if token_data["access_token"] is None:
        return FileResponse("templates/error.html")
    
    response = FileResponse("templates/todo.html")
    response.set_cookie(key="token", value=token_data["access_token"])

    return response

@app.post("/token")
def create_token(db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.username == "Aurelion Sol").first()

    if user is None or user.password != "Marcio":
        return JSONResponse(content={"message": "Incorrect username or password"}, status_code=401)

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(identity={"sub": user.username}, secret_key=SECRET_KEY, expires_delta=access_token_expires)

    return JSONResponse(content={"access_token": access_token, "token_type": "bearer", "username": user.username}, status_code=200)

def verify_auth(request: Request):

    authorization = request.headers.get("Authorization")

    print(authorization)

    if authorization is None:
        return FileResponse("templates/error.html")
    
    token = authorization.split("Bearer ")[1]

    if len(token) == 0:
        return {"error": "Invalid token"}

    verification = verify_jwt_token(token=token, secret_key=SECRET_KEY)

    if verification.get("error") is not None:
        return {"error": "Invalid token"}
    
    return {"error": None}