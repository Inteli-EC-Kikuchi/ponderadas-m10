package models

import (
	"fmt"
	"net/http"
)

type User struct{
	ID int `json:"id"`
	Name string `json:"name"`
}

type UserList struct{
	Users []User `json:"todos"`
}

func (td *User) Bind(r *http.Request) error {
	
	if td.Name == ""{
		return fmt.Errorf("name is a required field")
	}

	return nil
}

func (*User) Render(w http.ResponseWriter, r *http.Request) error {
	return nil
}

func (*UserList) Render(w http.ResponseWriter, r *http.Request) error {
	return nil
}