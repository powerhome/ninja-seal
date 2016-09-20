package github

import (
	"github.com/gin-gonic/gin"
)

type PullRequest struct {
	Title string `json:"title"`
}

type PullRequestEvent struct {
	Action      string      `json:"action"`
	PullRequest PullRequest `json:"pull_request"`
}

func Webhook(c *gin.Context) {
	var payload PullRequestEvent

	if c.BindJSON(&payload) == nil {
		c.JSON(200, gin.H{"pr_title": payload.PullRequest.Title})
	}
}
