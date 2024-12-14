package service

import (
	"github.com/loloneme/pr13/backend/internal/entities"
	"github.com/loloneme/pr13/backend/internal/repository"
)

type OrderService struct {
	repo repository.Order
}

func NewOrderService(repo repository.Order) *OrderService {
	return &OrderService{repo: repo}
}

func (s *OrderService) CreateOrder(order *entities.Order) (int64, error) {
	orderID, err := s.repo.CreateOrder(order)
	if err != nil {
		return 0, err
	}

	err = s.repo.ClearCart(order.UserID)
	if err != nil {
		return 0, err
	}
	return orderID, nil
}

func (s *OrderService) GetOrdersForUser(userID string) ([]*entities.Order, error) {
	return s.repo.GetOrdersForUser(userID)
}
