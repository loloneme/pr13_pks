package repository

import (
	"database/sql"
	"fmt"
	"github.com/jmoiron/sqlx"
	"github.com/loloneme/pr13/backend/internal/entities"
)

type CartPostgres struct {
	db *sqlx.DB
}

func NewCartPostgres(db *sqlx.DB) *CartPostgres {
	return &CartPostgres{db: db}
}

func (r *CartPostgres) AddToCart(cartItem *entities.CartItem) (int64, error) {
	var cartItemID int64

	existsQuery := `SELECT cart_item_id FROM cart_item WHERE volume_id = $1 AND user_id = $2 AND temperature = $3`
	err := r.db.Get(&cartItemID, existsQuery, cartItem.Volume.ID, cartItem.UserID, cartItem.Temperature)
	if err == nil {
		updateQuery := `UPDATE cart_item 
                    SET quantity = quantity + $1
                    WHERE cart_item_id = $2`
		_, err := r.db.Exec(updateQuery, cartItem.Quantity, cartItemID)
		if err != nil {
			return 0, fmt.Errorf("error updating cart item: %v", err)
		}
		return cartItemID, nil
	} else if err != sql.ErrNoRows {
		return 0, fmt.Errorf("error checking cart item existence: %v", err)
	}

	query := `INSERT INTO cart_item 
    (volume_id, user_id, temperature, quantity) VALUES ($1, $2, $3, $4) RETURNING cart_item_id`

	err = r.db.QueryRowx(query, cartItem.Volume.ID, cartItem.UserID, cartItem.Temperature, cartItem.Quantity).Scan(&cartItemID)
	if err != nil {
		return 0, fmt.Errorf("error adding to cart: %v", err)
	}

	return cartItemID, nil
}

func (r *CartPostgres) GetCart(userID string) ([]*entities.CartItem, error) {
	var res []*entities.CartItem

	query := `
		SELECT 
		c.cart_item_id,
		c.user_id,
		c.temperature,
		c.quantity,
		v.volume_id AS "volume.volume_id",
		v.volume AS "volume.volume",
		v.price AS "volume.price",
		d.drink_id AS "drink.drink_id",
		d.name AS "drink.name",
		d.image AS "drink.image"
		FROM cart_item c
		JOIN volumes v ON c.volume_id = v.volume_id
		JOIN drink d ON v.drink_id = d.drink_id
		WHERE c.user_id = $1`

	err := r.db.Select(&res, query, userID)
	if err != nil {
		return nil, fmt.Errorf("error getting cart for user %d: %v", userID, err)
	}

	//for i := range res {
	//	res[i].Volume = entities.Volume{
	//		ID:     res[i].Volume.ID,
	//		Volume: res[i].Volume.Volume,
	//		Price:  res[i].Volume.Price,
	//		Drink: entities.Drink{
	//			ID:       res[i].Volume.Drink.ID,
	//			Name:     res[i].Volume.Drink.Name,
	//			ImageURL: res[i].Volume.Drink.ImageURL,
	//		},
	//	}
	//}
	if res == nil {
		res = []*entities.CartItem{}
	}

	return res, nil
}

func (r *CartPostgres) UpdateCartItem(cartItemID int64, quantity int64) error {
	query := `UPDATE "cart_item" 
			  SET "quantity" = $1
			  WHERE "cart_item_id" = $2`

	_, err := r.db.Exec(query, quantity, cartItemID)
	if err != nil {
		return fmt.Errorf("error updating cart item with ID %d: %v", cartItemID, err)
	}

	return nil
}

func (r *CartPostgres) DeleteCartItem(cartItemID int64, userID string) error {
	query := `DELETE FROM "cart_item"
			WHERE "cart_item_id" = $1 AND user_id = $2`

	_, err := r.db.Exec(query, cartItemID, userID)
	if err != nil {
		return fmt.Errorf("error deleting cart item with ID %d: %v", cartItemID, err)
	}
	return nil
}
