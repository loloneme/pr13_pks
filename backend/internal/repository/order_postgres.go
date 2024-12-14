package repository

import (
	"fmt"
	"github.com/jmoiron/sqlx"
	"github.com/loloneme/pr13/backend/internal/entities"
)

type OrderPostgres struct {
	db *sqlx.DB
}

func NewOrderPostgres(db *sqlx.DB) *OrderPostgres {
	return &OrderPostgres{db: db}
}

func (r *OrderPostgres) CreateOrder(order *entities.Order) (int64, error) {
	var orderID int64

	orderQuery := `INSERT INTO "orders" (user_id, date, total) VALUES ($1, CURRENT_DATE, $2) RETURNING order_id`
	fmt.Println(order.UserID)
	err := r.db.QueryRowx(orderQuery, order.UserID, order.Total).Scan(&orderID)
	if err != nil {
		return 0, fmt.Errorf("error creating order: %v", err)
	}

	for _, item := range order.Items {
		query := `INSERT INTO "order_item" (order_id, volume_id, temperature, quantity) VALUES ($1, $2, $3, $4)`

		_, err := r.db.Exec(query, orderID, item.Volume.ID, item.Temperature, item.Quantity)
		if err != nil {
			return 0, fmt.Errorf("error connecting item to order: %v", err)
		}
	}

	return orderID, nil
}

func (r *OrderPostgres) GetOrdersForUser(userID string) ([]*entities.Order, error) {
	rows, err := r.db.Queryx(`
		SELECT 
			o.order_id, o.date, o.total AS total_cost, o.user_id,
			oi.order_id as order_item_id, oi.temperature, oi.quantity, 
			d.drink_id, d.name AS drink_name, 
			v.volume_id, v.volume, v.price
		FROM orders o 
		LEFT JOIN order_item oi ON o.order_id = oi.order_id
		LEFT JOIN volumes v ON oi.volume_id = v.volume_id
		LEFT JOIN drink d ON d.drink_id = v.drink_id
		WHERE o.user_id = $1;
	`, userID)

	if err != nil {
		return nil, fmt.Errorf("error getting users orders: %v", err)
	}
	defer rows.Close()

	orders := make(map[int64]*entities.Order)
	for rows.Next() {
		var row entities.OrderRow
		if err := rows.StructScan(&row); err != nil {
			return nil, fmt.Errorf("error scanning order: %v", err)
		}

		order, ok := orders[row.OrderID]
		if !ok {
			order = &entities.Order{
				OrderID: row.OrderID,
				UserID:  row.UserID,
				Items:   []entities.OrderItem{},
				Date:    row.Date,
				Total:   row.Total,
			}

			orders[row.OrderID] = order
		}

		order.Items = append(order.Items, entities.OrderItem{
			ID:          row.OrderItemID,
			DrinkName:   row.DrinkName,
			Volume:      entities.Volume{ID: row.VolumeID, Volume: row.Volume, Price: row.Price},
			Temperature: row.Temperature,
			Quantity:    row.Quantity,
		})
	}

	ordersRes := make([]*entities.Order, 0, len(orders))
	for _, order := range orders {
		ordersRes = append(ordersRes, order)
	}

	return ordersRes, nil
}

func (r *OrderPostgres) ClearCart(userID string) error {
	query := `DELETE FROM "cart_item" WHERE user_id = $1`

	_, err := r.db.Exec(query, userID)
	if err != nil {
		return fmt.Errorf("error clearing cart for user: %v", err)
	}
	return nil
}
