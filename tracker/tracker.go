package tracker

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

// Webhook LOL
func Webhook(c *gin.Context) {
	var body gin.H
	if c.Bind(&body) == nil {
		fmt.Printf("%v", body)
	}
}
