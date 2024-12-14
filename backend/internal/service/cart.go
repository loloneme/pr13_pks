package service

import (
	"github.com/loloneme/pr13/backend/internal/entities"
	"github.com/loloneme/pr13/backend/internal/repository"
)

type CartService struct {
	repo repository.Cart
}

func NewCartService(repo repository.Cart) *CartService {
	return &CartService{repo: repo}
}

func (s *CartService) AddToCart(cartItem *entities.CartItem) (int64, error) {
	return s.repo.AddToCart(cartItem)
}

func (s *CartService) GetCart(userID string) ([]*entities.CartItem, error) {
	return s.repo.GetCart(userID)
}

func (s *CartService) UpdateCartItem(cartItemID int64, quantity int64) error {
	return s.repo.UpdateCartItem(cartItemID, quantity)
}

func (s *CartService) DeleteCartItem(cartItemID int64, userID string) error {
	return s.repo.DeleteCartItem(cartItemID, userID)
}
