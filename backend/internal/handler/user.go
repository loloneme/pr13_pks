package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/loloneme/pr13/backend/internal/entities"
	"net/http"
)

func (h *Handler) Register(c *gin.Context) {
	var user entities.User
	if err := c.BindJSON(&user); err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	err := h.services.User.CreateUser(&user)
	if err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}
	c.JSON(201, map[string]interface{}{
		"message": "Успешно зарегистрирован!",
	})
}

func (h *Handler) GetUser(c *gin.Context) {
	userID := c.Param("user_id")

	res, err := h.services.User.GetUser(userID)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
	}

	c.JSON(200, res)
}

func (h *Handler) UpdateUser(c *gin.Context) {
	userID := c.Param("user_id")

	var user *entities.User
	if err := c.BindJSON(&user); err != nil {
		ErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	user.UserID = userID

	err := h.services.User.UpdateUser(user)
	if err != nil {
		ErrorResponse(c, http.StatusInternalServerError, err.Error())
	}

	c.JSON(200, map[string]interface{}{
		"message": "Успешно обновлено!",
	})
}
