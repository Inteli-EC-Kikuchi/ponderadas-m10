package database

import (
	"database/sql"
	"github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/models"
)

func (db Database) GetAllToDos() (*models.ToDoList, error) {
	list := &models.ToDoList{}

	rows, err := db.Conn.Query("SELECT * FROM todos ORDER BY ID DESC")

	if err != nil {
		return list, err
	}

	for rows.Next() {
		var todo models.ToDo

		err := rows.Scan(&todo.ID, &todo.Name, &todo.Description, &todo.UserID)

		if err != nil {
			return list, err
		}

		list.ToDos = append(list.ToDos, todo)
	}

	return list, nil
}

func (db Database) AddToDo(todo *models.ToDo) error {
	var id int
	var userId int

	query := `INSERT INTO todos (name, description) VALUES ($1, $2) RETURNING id, user_id`
	err := db.Conn.QueryRow(query, todo.Name, todo.Description).Scan(&id, &userId)

	if err != nil {
		return err
	}

	todo.ID = id
	todo.UserID = userId

	return nil
}

func (db Database) GetToDoById(todoId int) (models.ToDo, error) {
	
	todo := models.ToDo{}

	query := `SELECT * FROM todos WHERE  id = $1;`
	
	row := db.Conn.QueryRow(query, todoId)

	switch err := row.Scan(&todo.ID, &todo.Name, &todo.Description, &todo.UserID); err {
		case sql.ErrNoRows:
			return todo, ErrNoMatch
		default:
			return todo, err
	}
}

func (db Database) DeleteToDo(todoId int) error {
	query := `DELETE FROM todos WHERE id = $1;`

	_, err := db.Conn.Exec(query, todoId)

	switch err {
		case sql.ErrNoRows:
			return ErrNoMatch
		default:
			return err
	}
}

func (db Database) UpdateToDo(todoId int, todoData models.ToDo) (models.ToDo, error) {
	todo := models.ToDo{}

	query := `UPDATE todos SET name=$1, description=$2 WHERE id=$3 RETURNING id, name, description, user_id`
	err := db.Conn.QueryRow(query, todoData.Name, todoData.Description, todoId).Scan(&todo.ID, &todo.Name, &todo.Description, &todo.UserID)

	if err != nil {
		if err == sql.ErrNoRows {
			return todo, ErrNoMatch
		}
		return todo, err
	}

	return todo, nil
}