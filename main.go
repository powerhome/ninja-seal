package main

import (
	"github.com/gin-gonic/gin"
	"github.com/powerhome/ninja-seal/github"
)

func main() {
	api := gin.Default()

	api.POST("/webhooks/github", github.Webhook)

	api.Run(":8080")
}
