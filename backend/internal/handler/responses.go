package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/loloneme/pr13/backend/internal/logger"
)

type errorResponse struct {
	Message string `json:"message"`
}

func ErrorResponse(c *gin.Context, statusCode int, err string) {
	logger.Logger.Error(err)
	c.AbortWithStatusJSON(statusCode, errorResponse{Message: err})
}
