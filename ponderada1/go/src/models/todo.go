package models

import (
	"fmt"
	"net/http"
)

type ToDo struct{
	ID int `json:"id"`
	Name string `json:"name"`
	Description string `json:"description"`
	UserID int `json:"user_id"`
}

type ToDoList struct{
	ToDos []ToDo `json:"todos"`
}

func (td *ToDo) Bind(r *http.Request) error {
	
	if td.Name == ""{
		return fmt.Errorf("name is a required field")
	}

	return nil
}

func (*ToDoList) Render(w http.ResponseWriter, r *http.Request) error {
	return nil
}

func (*ToDo) Render(w http.ResponseWriter, r *http.Request) error {
	return nil
}