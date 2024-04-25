package main

import (
	"fmt"
	"net/http"
	"os"

	mw "github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/middleware"
	"github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/routes"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/jwtauth/v5"

)

var tokenAuth *jwtauth.JWTAuth

func init(){

	secret_key := os.Getenv("SECRET_KEY")

	tokenAuth = jwtauth.New("HS256", []byte(secret_key), nil)

	_, tokenString, _ := tokenAuth.Encode(map[string]interface{}{"user_id": 123})
	fmt.Printf("DEBUG: a sample jwt is %s\n\n", tokenString)
}

func main(){

	defer routes.DbInstance.Conn.Close()

	r := chi.NewRouter()

	r.Use(middleware.Logger)
	r.Use(middleware.CleanPath)
	r.Use(middleware.Recoverer)

	r.Get("/", routes.RenderRoot)
	r.Get("/todo", routes.RenderToDo)
	r.Get("/login", routes.RenderLogin)
	r.Get("/register", routes.RenderRegister)

	
	r.Get("/login", routes.RenderLogin)


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
		
		// r.Use(jwtauth.Verifier(tokenAuth))
		// r.Use(jwtauth.Authenticator(tokenAuth))
		
		r.Get("/", routes.RenderTasks)
		r.Post("/", routes.CreateTask)
		r.Put("/", routes.UpdateTask)
		r.Delete("/", routes.DeleteTask)
	})

	

	fmt.Println(http.ListenAndServe(":3333", r))
}