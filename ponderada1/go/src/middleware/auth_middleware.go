package middleware

import (
	"net/http"
	"fmt"
)

func HandleAuth(next http.Handler) http.Handler{
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		fmt.Println("Passing trought the middleware! Going next...")

		next.ServeHTTP(w, r)
	})
}