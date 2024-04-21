from fastapi import FastAPI, Depends
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

from sqlalchemy.orm import Session

from database.database import SessionLocal, engine, Base
from database import models

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.mount("/static", StaticFiles(directory="templates"), name="static")

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
def create_user(db: Session = Depends(get_db)):

    user = models.User(username="User 1", email="a@b.com", password="1234")

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
