package database

import (
	"database/sql"
	"github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/models"
)

func (db Database) GetAllUsers() (*models.UserList, error) {
	list := &models.UserList{}

	rows, err := db.Conn.Query("SELECT * FROM users ORDER BY ID DESC")

	if err != nil {
		return list, err
	}

	for rows.Next() {
		var user models.User

		err := rows.Scan(&user.ID, &user.Name)

		if err != nil {
			return list, err
		}

		list.Users = append(list.Users, user)
	}

	return list, nil
}

func (db Database) AddUser(user *models.User) error {
	var id int

	query := `INSERT INTO users (name) VALUES ($1) RETURNING id`
	err := db.Conn.QueryRow(query, user.Name).Scan(&id)

	if err != nil {
		return err
	}

	user.ID = id

	return nil
}

func (db Database) GetUserById(userId int) (models.User, error) {
	
	user := models.User{}

	query := `SELECT * FROM users WHERE  id = $1;`
	
	row := db.Conn.QueryRow(query, userId)

	switch err := row.Scan(&user.ID, &user.Name); err {
		case sql.ErrNoRows:
			return user, ErrNoMatch
		default:
			return user, err
	}
}

func (db Database) DeleteUser(userId int) error {
	query := `DELETE FROM users WHERE id = $1;`

	_, err := db.Conn.Exec(query, userId)

	switch err {
		case sql.ErrNoRows:
			return ErrNoMatch
		default:
			return err
	}
}

func (db Database) UpdateUser(todoId int, todoData models.User) (models.User, error) {
	user := models.User{}

	query := `UPDATE users SET name=$1 WHERE id=$2 RETURNING id, name`
	err := db.Conn.QueryRow(query, todoData.Name, todoId).Scan(&user.ID, &user.Name)

	if err != nil {
		if err == sql.ErrNoRows {
			return user, ErrNoMatch
		}
		return user, err
	}

	return user, nil
}