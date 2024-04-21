from datetime import datetime, timedelta
import jwt
import requests

from fastapi import FastAPI, Depends, Form, Request
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

from sqlalchemy.orm import Session

from database.database import SessionLocal, engine, Base
from database import models

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.mount("/static", StaticFiles(directory="templates"), name="static")


SECRET_KEY = "b0e0e5b4a8f1c1e2b8d5c3a8b3b9d7e2"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

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

@app.get("/tasks")
def tasks(db: Session = Depends(get_db)):
    
    db_tasks = db.query(models.Task).all()

    tasks = [{"id": task.id, "name": task.name} for task in db_tasks]
    
    return {"tasks": tasks}

@app.post("/tasks")
def create_task(db: Session = Depends(get_db)):
    
    task = models.Task(name="Task 1", description="Description 1")

    db.add(task)
    db.commit()
    db.refresh(task)
    return {"message": "Task created successfully", "task": task}

@app.put("/tasks/{task_id}")
def update_task(task_id: int, db: Session = Depends(get_db)):

    task = db.query(models.Task).filter(models.Task.id == task_id).first()

    task.name = "Task 1 updated"
    db.commit()
    db.refresh(task)

    return {"message": f"Task {task_id} updated successfully"}

@app.delete("/tasks/{task_id}")
def delete_task(task_id: int, db: Session = Depends(get_db)):

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

    if token_data.status_code != 200:
        return FileResponse("templates/error.html")
    
    response = FileResponse("templates/todo.html")
    response.set_cookie(key="access token", value=token_data["access_token"])

    return response

@app.post("/token")
async def create_token(request: Request, db: Session = Depends(get_db)):

    data = await request.json()

    user = db.query(models.User).filter(models.User.username == data["username"]).first()

    if user is None or user.password != data["password"]:
        return {"message": "Incorrect username or password"}

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(identity={"sub": user.username}, secret_key=SECRET_KEY, expires_delta=access_token_expires)

    return {"access_token": access_token, "token_type": "bearer", "username": user.username}

def create_access_token(identity: str, secret_key: str, expires_delta: timedelta):
    expire = datetime.utcnow() + expires_delta
    to_encode = {"exp": expire, "sub": identity}
    encoded_jwt = jwt.encode(to_encode, secret_key, algorithm="HS256")
    return encoded_jwt

# @app.get("/protected")
# def protected_route(credentials: HTTPAuthorizationCredentials = Depends(security)):
#     return {"message": "This is a protected route"}