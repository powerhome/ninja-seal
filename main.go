package main

import (
	"github.com/gin-gonic/gin"
	"github.com/powerhome/ninja-seal/github"
	"github.com/powerhome/ninja-seal/tracker"
)

func main() {
	api := gin.Default()

	api.POST("/webhooks/github", github.Webhook)
	api.POST("/webhooks/tracker", tracker.Webhook)

	api.Run(":8080")
}
