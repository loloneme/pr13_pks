package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/loloneme/pr13/backend/internal/entities"
	"net/http"
	"strconv"
)

func (h *Handler) AddToCart(c *gin.Context) {
	userID := c.Param("user_id")

	var cartItem entities.CartItem
	if err := c.BindJSON(&cartItem); err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	cartItem.UserID = userID

	cartItemID, err := h.services.AddToCart(&cartItem)
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}
	c.JSON(201, map[string]interface{}{
		"cart_item_id": cartItemID,
		"message":      "Успешно добавлено!",
	})
}

func (h *Handler) DeleteFromCart(c *gin.Context) {
	userID := c.Param("user_id")

	itemID, err := strconv.ParseInt(c.Param("item_id"), 10, 64)
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	err = h.services.DeleteCartItem(itemID, userID)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
	}

	c.JSON(200, map[string]interface{}{
		"message": "Успешно удалено!",
	})
}

func (h *Handler) GetCart(c *gin.Context) {
	userID := c.Param("user_id")

	res, err := h.services.GetCart(userID)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
	}

	c.JSON(200, res)
}

func (h *Handler) UpdateCart(c *gin.Context) {
	_ = c.Param("user_id")

	itemID, err := strconv.ParseInt(c.Param("item_id"), 10, 64)
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	var requestBody struct {
		Quantity int64 `json:"quantity"`
	}

	if err := c.ShouldBindJSON(&requestBody); err != nil {
		ErrorResponse(c, http.StatusBadRequest, "invalid request body")
		return
	}

	if requestBody.Quantity <= 0 {
		ErrorResponse(c, http.StatusBadRequest, "quantity must be greater than zero")
		return
	}

	err = h.services.UpdateCartItem(itemID, requestBody.Quantity)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(200, map[string]interface{}{
		"message": "Успешно обновлено!",
	})
}
