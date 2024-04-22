package routes

import "net/http"

func RenderTasks(w http.ResponseWriter, r *http.Request){
	w.Write([]byte("Tasks"))
}

func CreateTask(w http.ResponseWriter, r *http.Request){
	w.Write([]byte("Task created successfully!"))
}

func UpdateTask(w http.ResponseWriter, r *http.Request){
	w.Write([]byte("Task updated succsessfully!"))
}

func DeleteTask(w http.ResponseWriter, r *http.Request){
	w.Write([]byte("Task deleted succsessfully!"))
}