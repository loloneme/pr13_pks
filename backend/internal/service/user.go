package service

import (
	"github.com/loloneme/pr13/backend/internal/entities"
	"github.com/loloneme/pr13/backend/internal/repository"
)

type UserService struct {
	repo repository.User
}

func NewUserService(repo repository.User) *UserService {
	return &UserService{repo: repo}
}

func (s *UserService) CreateUser(profile *entities.User) error {
	return s.repo.CreateUser(profile)
}

func (s *UserService) GetUser(userID string) (*entities.User, error) {
	return s.repo.GetUser(userID)
}

func (s *UserService) UpdateUser(profile *entities.User) error {
	return s.repo.UpdateUser(profile)
}
