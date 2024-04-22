package routes

import "net/http"

func RenderUsers(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(200)
	w.Write([]byte("Users"))
}

func CreateUser(w http.ResponseWriter, r *http.Request){
	w.WriteHeader(201)
	w.Write([]byte("User created successfully!"))
}

func UpdateUser(w http.ResponseWriter, r *http.Request){
	w.Write([]byte("User updated succsessfully!"))
}

func DeleteUser(w http.ResponseWriter, r *http.Request){
	w.Write([]byte("User deleted succsessfully!"))
}



func RenderUserById(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(200)
	w.Write([]byte("User by Id!"))
}