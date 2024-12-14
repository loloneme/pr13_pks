package entities

type Drink struct {
	ID          int64    `json:"drink_id" db:"drink_id"`
	Name        string   `json:"name" db:"name"`
	ImageURL    string   `json:"image" db:"image"`
	Description string   `json:"description,omitempty" db:"description"`
	Compound    string   `json:"compound,omitempty" db:"compound"`
	Cold        bool     `json:"is_cold,omitempty" db:"is_cold"`
	Hot         bool     `json:"is_hot,omitempty" db:"is_hot"`
	Volumes     []Volume `json:"volumes,omitempty"`
	IsFavorite  bool     `json:"is_favorite"`
}

type Volume struct {
	ID     int64  `json:"volume_id" db:"volume_id"`
	Volume string `json:"volume" db:"volume"`
	Price  int64  `json:"price" db:"price"`
}

type CartItem struct {
	ID          int64  `json:"cart_item_id" db:"cart_item_id"`
	UserID      string `json:"user_id" db:"user_id"`
	Drink       Drink  `json:"drink"`
	Volume      Volume `json:"volume"`
	Temperature string `json:"temperature" db:"temperature"`
	Quantity    int64  `json:"quantity"`
}

type User struct {
	UserID   string `json:"user_id" db:"user_id"`
	FullName string `json:"fullname" db:"fullname"`
	Image    string `json:"user_image" db:"image"`
	Email    string `json:"email" db:"email"`
	Phone    string `json:"phone" db:"phone"`
}

type OrderItem struct {
	ID          int64  `json:"order_item_id" db:"order_item_id"`
	DrinkName   string `json:"drink_name" db:"drink_name"`
	Volume      Volume `json:"volume"`
	Temperature string `json:"temperature" db:"temperature"`
	Quantity    int64  `json:"quantity"`
}

type Order struct {
	OrderID int64       `json:"order_id" db:"order_id"`
	UserID  string      `json:"user_id" db:"user_id"`
	Items   []OrderItem `json:"items"`
	Date    string      `json:"date" db:"date"`
	Total   int64       `json:"total_cost" db:"total"`
}

type OrderRow struct {
	OrderID     int64  `db:"order_id"`
	UserID      string `db:"user_id"`
	Date        string `db:"date"`
	Total       int64  `db:"total_cost"`
	OrderItemID int64  `db:"order_item_id"`
	Temperature string `db:"temperature"`
	Quantity    int64  `db:"quantity"`
	DrinkID     int64  `db:"drink_id"`
	DrinkName   string `db:"drink_name"`
	VolumeID    int64  `db:"volume_id"`
	Volume      string `db:"volume"`
	Price       int64  `db:"price"`
}
