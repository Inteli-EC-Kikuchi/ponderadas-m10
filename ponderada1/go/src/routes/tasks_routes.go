package routes

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/models"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/render"
)

func RenderTasks(w http.ResponseWriter, r *http.Request){

	todos, err := DbInstance.GetAllToDos()
	
	if err != nil {
		fmt.Println(err)
        return
	}
	
	w.WriteHeader(200)

	json.NewEncoder(w).Encode(todos)
}

func CreateTask(w http.ResponseWriter, r *http.Request){
	
	todo := &models.ToDo{}

	if err := render.Bind(r, todo); err != nil {
		fmt.Println(err)
		return
	}

	if err := DbInstance.AddToDo(todo); err != nil {
		fmt.Println(err)
        return
	}

	w.WriteHeader(201)
	w.Write([]byte("Add Task succsessfully!\n"))
}

func UpdateTask(w http.ResponseWriter, r *http.Request){

	todo := &models.ToDo{}

	if err := render.Bind(r, todo); err != nil {
		fmt.Println(err)
		return
	}

	taskId, err := strconv.Atoi(chi.URLParam(r, "taskID"))

	if err != nil {
		fmt.Println(err)
		return
	}

	if _, err := DbInstance.UpdateToDo(taskId, *todo); err != nil	{
		fmt.Println(err)
		return
	}

	w.WriteHeader(204)
}

func DeleteTask(w http.ResponseWriter, r *http.Request){
	
	taskId, err := strconv.Atoi(chi.URLParam(r, "taskID"))

	if err != nil {
		fmt.Println(err)
		return
	}

	if err := DbInstance.DeleteToDo(taskId); err != nil	{
		fmt.Println(err)
		return
	}

	w.WriteHeader(202)
	w.Write([]byte("Task deleted succsessfully!"))
}