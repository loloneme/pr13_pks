package repository

import (
	"fmt"
	"github.com/jmoiron/sqlx"
	"github.com/loloneme/pr13/backend/internal/entities"
)

type UserPostgres struct {
	db *sqlx.DB
}

func NewUserPostgres(db *sqlx.DB) *UserPostgres {
	return &UserPostgres{db: db}
}

func (r *UserPostgres) CreateUser(profile *entities.User) error {
	query := `INSERT INTO "user" (user_id, fullname, image, email, phone) VALUES ($1, $2, $3, $4, $5)`

	_, err := r.db.Exec(query, profile.UserID, profile.FullName, profile.Image, profile.Email, profile.Phone)
	if err != nil {
		return fmt.Errorf("error creating user %s", err.Error())
	}
	return nil
}

func (r *UserPostgres) GetUser(userID string) (*entities.User, error) {
	var user entities.User

	query := `SELECT * FROM "user" WHERE user_id = $1`

	err := r.db.Get(&user, query, userID)
	if err != nil {
		return nil, fmt.Errorf("error getting user %v", err)
	}

	return &user, nil
}

func (r *UserPostgres) UpdateUser(profile *entities.User) error {
	query := `UPDATE "user" SET fullname = $1, image = $2, phone = $3 WHERE user_id = $4`

	_, err := r.db.Exec(query, profile.FullName, profile.Image, profile.Phone, profile.UserID)
	if err != nil {
		return fmt.Errorf("error updating user: %v", err)
	}

	return nil
}
