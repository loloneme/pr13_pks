package backend

import (
	"context"
	"github.com/rs/cors"
	"net/http"
	"time"
)

type Config struct {
	Port        string        `env:"HTTP_SERVER_PORT"`
	Timeout     time.Duration `env:"HTTP_SERVER_TIMEOUT"`
	IdleTimeout time.Duration `env:"HTTP_SERVER_IDLE_TIMEOUT"`
}

type Server struct {
	httpServer *http.Server
}

func (s *Server) Run(cfg Config, handler http.Handler) error {
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},                                                // Разрешить запросы только с этого источника
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"}, // Разрешить методы
		AllowedHeaders:   []string{"Origin", "Content-Type"},                           // Разрешить заголовки
		AllowCredentials: true,                                                         // Разрешить отправку куки и заголовка авторизации с клиента
	})

	s.httpServer = &http.Server{
		Addr:           ":" + cfg.Port,
		Handler:        c.Handler(handler),
		MaxHeaderBytes: 1 << 20,
		ReadTimeout:    cfg.Timeout,
		WriteTimeout:   cfg.Timeout,
		IdleTimeout:    cfg.IdleTimeout,
	}

	return s.httpServer.ListenAndServe()
}

func (s *Server) ShutDown(ctx context.Context) error {
	return s.httpServer.Shutdown(ctx)
}
