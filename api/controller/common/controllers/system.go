package controllers

import (
	"github.com/gin-gonic/gin"
	"md_docs_api/controller/common"
	"net/http"
)

func GetSystemHealth(context *gin.Context) {

	systemHealth := models.SystemHealth{Status: models.SystemRunning}
	context.JSON(http.StatusOK, systemHealth)
}
