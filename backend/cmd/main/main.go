package main

import (
	"github.com/loloneme/pr13/backend"
	"github.com/loloneme/pr13/backend/internal/handler"
	"github.com/loloneme/pr13/backend/internal/logger"
	"github.com/loloneme/pr13/backend/internal/repository"
	"github.com/loloneme/pr13/backend/internal/service"
	"log/slog"
	"time"
)

type Config struct {
	HTTPServer backend.Config
}

func main() {
	logger.InitLogger(slog.LevelDebug)
	logger.Logger.Info("Logger initialized")

	//currDir, err := os.Getwd()
	//if err != nil {
	//	logger.Logger.Error("Failed to find current dir")
	//	return
	//}
	//
	//err = godotenv.Load(fmt.Sprintf("%s/.env", currDir))
	//if err != nil {
	//	logger.Logger.Error("Failed to find current directory", "error", err)
	//	return
	//}
	//
	//var cfg Config
	//if err := cleanenv.ReadEnv(&cfg); err != nil {
	//	logger.Logger.Error("Failed to read environment variables", "error", err)
	//	return
	//}

	db, err := repository.ConnectToDB(repository.Config{
		Host:     "localhost",
		Port:     5432,
		Name:     "drinks",
		Username: "postgres",
		Password: "loloneme",
	})

	if err != nil {
		logger.Logger.Error("Failed to connect to database", "error", err)
		return
	}

	repos := repository.NewRepository(db)
	services := service.NewService(repos)
	handlers := handler.NewHandler(services)

	srv := new(backend.Server)
	if err := srv.Run(backend.Config{
		Port:        "8080",
		Timeout:     time.Second * 10,
		IdleTimeout: time.Second * 60,
	}, handlers.InitRoutes()); err != nil {
		logger.Logger.Error("Failed to connect to server", "error", err)
		return
	}
}
