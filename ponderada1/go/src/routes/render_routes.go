package routes

import (
	"encoding/json"
	"html/template"
	"io"
	"net/http"

	"github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/models"
)

func RenderRoot(w http.ResponseWriter, r *http.Request) {
	t, err := template.ParseFiles("./templates/index.html")

	if err != nil {
		panic(err)
	}

	t.Execute(w, nil)
}

func RenderLogin(w http.ResponseWriter, r *http.Request) {
	t, err := template.ParseFiles("./templates/login.html")

	if err != nil {
		panic(err)
	}

	t.Execute(w, nil)
}

func RenderRegister(w http.ResponseWriter, r *http.Request) {
	t, err := template.ParseFiles("./templates/register.html")

	if err != nil {
		panic(err)
	}

	t.Execute(w, nil)
}


func RenderToDo(w http.ResponseWriter, r *http.Request){
	
	todos := &models.ToDoList{}
	
	t, err := template.ParseFiles("./templates/todo.html")

	if err != nil {
		panic(err)
	}

	requestURL := "http://localhost:3333/tasks"

	res, _ := http.Get(requestURL)

	bodyBytes, _ := io.ReadAll(res.Body)

	_ = json.Unmarshal(bodyBytes, &todos)

	t.Execute(w, todos)
}