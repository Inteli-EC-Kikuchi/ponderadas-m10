package main

import (
	"net/http"

	routes "github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/routes"
	mw "github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/middleware"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main(){

	r := chi.NewRouter()

	r.Use(middleware.Logger)

	r.Get("/", RenderRoot)

	r.Route("/users", func(r chi.Router) {
		r.Get("/", routes.RenderUsers)
		r.Post("/", routes.CreateUser)
		r.Put("/", routes.UpdateUser)
		r.Delete("/", routes.DeleteUser)

		r.Route("/{userId}", func(r chi.Router) {
			r.Use(mw.HandleAuth)
			r.Get("/", routes.RenderUserById)
		})

	})

	r.Route("/tasks", func(r chi.Router) {
		r.Get("/", routes.RenderTasks)
		r.Post("/", routes.CreateTask)
		r.Put("/", routes.UpdateTask)
		r.Delete("/", routes.DeleteTask)
	})

	http.ListenAndServe(":3333", r)
}

func RenderRoot(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello World!"))
}