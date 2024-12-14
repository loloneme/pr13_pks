package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/loloneme/pr13/backend/internal/entities"
	"net/http"
)

func (h *Handler) GetOrdersForUser(c *gin.Context) {
	userID := c.Param("user_id")
	var err error

	res, err := h.services.Order.GetOrdersForUser(userID)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
	}

	c.JSON(200, res)
}

func (h *Handler) CreateOrder(c *gin.Context) {
	var order entities.Order
	if err := c.BindJSON(&order); err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	orderID, err := h.services.Order.CreateOrder(&order)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(201, map[string]interface{}{
		"order_id": orderID,
		"message":  "Успешно добавлено!",
	})
}
