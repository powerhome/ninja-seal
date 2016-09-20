package github

import (
	"bytes"
	"encoding/json"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/go-github/github"
)

func client() *http.Client {
	transport := &github.BasicAuthTransport{
		Username: "drborges",
		Password: "dbbbb25ef4dfce434719d82c47ad5dc32af96532",
	}

	return transport.Client()
}

// Webhook LOL
func Webhook(c *gin.Context) {
	var payload github.PullRequestEvent

	if c.BindJSON(&payload) == nil {
		body := map[string]string{
			"state":   "pending",
			"context": "Ninja Approval Seal",
		}

		strB, _ := json.Marshal(body)
		client().Post(*payload.PullRequest.StatusesURL, "application/json", bytes.NewReader(strB))
	}
}
