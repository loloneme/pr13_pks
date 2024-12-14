package repository

import (
	"fmt"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	"log"
)

type Config struct {
	Host     string `env:"POSTGRES_HOST"`
	Port     int    `env:"POSTGRES_PORT"`
	Name     string `env:"POSTGRES_DB_NAME"`
	Username string `env:"POSTGRES_USER"`
	Password string `env:"POSTGRES_PASSWORD"`
}

func ConnectToDB(cfg Config) (*sqlx.DB, error) {
	connStr := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		cfg.Host, cfg.Port, cfg.Username, cfg.Password, cfg.Name)

	db, err := sqlx.Connect("postgres", connStr)
	if err != nil {
		log.Printf("error connecting to database %s", err)
		return nil, err

	}
	err = db.Ping()
	if err != nil {
		log.Fatalf("error pinging database %s", err)
		return nil, err
	}

	return db, nil
}
