package routes

import (
	"os"
	"log"

	"github.com/joho/godotenv"
	"github.com/Inteli-EC-Kikuchi/ponderadas-m10/src/database"
)

var DbInstance database.Database

func init(){

	err := godotenv.Load("../.env")

	if err != nil {
		panic("Could not load .env")
	}

	dbUser, dbPassword, dbName := 
		os.Getenv("POSTGRES_USER"),
		os.Getenv("POSTGRES_PASSWORD"),
		os.Getenv("POSTGRES_DB")
	
	DbInstance, err = database.Initialize(dbUser, dbPassword, dbName)

	if err != nil {
		log.Fatalf("Could not set up database: %v", err)
	}
}

