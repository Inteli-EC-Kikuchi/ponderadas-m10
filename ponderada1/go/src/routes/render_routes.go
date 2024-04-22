package routes

import(
	"net/http"
	"html/template"
)

type ToDo struct {
	Items []string
}

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
	t, err := template.ParseFiles("./templates/todo.html")

	if err != nil {
		panic(err)
	}

	data := ToDo{
		Items: []string{"Item 1", "Item 2", "Item 3"},
	}

	t.Execute(w, data)
}