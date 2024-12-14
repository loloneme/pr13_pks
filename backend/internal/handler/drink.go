package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/loloneme/pr13/backend/internal/entities"
	"net/http"
	"strconv"
)

func (h *Handler) GetAllDrinks(c *gin.Context) {
	userID := c.Param("user_id")
	var err error

	res, err := h.services.GetDrinks(userID)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
	}

	c.JSON(200, res)
}

func (h *Handler) GetDrinkByID(c *gin.Context) {
	drinkID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	res, err := h.services.GetDrinkByID(int64(drinkID))
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(200, res)
}

func (h *Handler) CreateDrink(c *gin.Context) {
	var drink entities.Drink
	if err := c.BindJSON(&drink); err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	drinkID, err := h.services.CreateDrink(&drink)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(201, map[string]interface{}{
		"drink_id": drinkID,
		"message":  "Успешно добавлено!",
	})
}

func (h *Handler) DeleteDrink(c *gin.Context) {
	drinkID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	err = h.services.DeleteDrink(int64(drinkID))
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
	}

	c.JSON(200, map[string]interface{}{
		"message": "Успешно удалено!",
	})
}

func (h *Handler) UpdateDrink(c *gin.Context) {
	drinkID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	var drink entities.Drink
	if err := c.BindJSON(&drink); err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	drink.ID = int64(drinkID)

	err = h.services.UpdateDrink(&drink)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(200, map[string]interface{}{
		"message": "Успешно обновлено!",
	})
}

func (h *Handler) ToggleFavorite(c *gin.Context) {
	userID := c.Param("user_id")

	drinkID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	err = h.services.ToggleFavorite(int64(drinkID), userID)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}
	c.JSON(200, map[string]interface{}{
		"message": "Успешно обновлено!",
	})
}
