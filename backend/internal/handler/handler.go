package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/loloneme/pr13/backend/internal/service"
)

type Handler struct {
	services *service.Service
}

func NewHandler(services *service.Service) *Handler {
	return &Handler{services: services}
}

func (h *Handler) InitRoutes() *gin.Engine {
	router := gin.New()

	router.Use(gin.Logger())
	api := router.Group("/handler")
	{
		drink := api.Group("/drink")
		{
			drink.GET("/all", h.GetAllDrinks)
			drink.GET("/all/:user_id", h.GetAllDrinks)
			drink.GET("/:id", h.GetDrinkByID)

			drink.PATCH("/:user_id/:id", h.ToggleFavorite)
			drink.PUT("/:id", h.UpdateDrink)

			drink.POST("", h.CreateDrink)
			drink.DELETE("/:id", h.DeleteDrink)
		}

		cart := api.Group("/cart")
		{
			cart.GET("/:user_id", h.GetCart)

			cart.PATCH("/:user_id/:item_id", h.UpdateCart)

			cart.POST("/:user_id", h.AddToCart)

			cart.DELETE("/:user_id/:item_id", h.DeleteFromCart)
		}

		user := api.Group("/user")
		{
			user.GET("/:user_id", h.GetUser)

			user.POST("/register", h.Register)

			user.PUT("/:user_id", h.UpdateUser)
		}

		order := api.Group("/order")
		{
			order.GET("/:user_id", h.GetOrdersForUser)

			order.POST("", h.CreateOrder)
		}
	}

	return router
}
