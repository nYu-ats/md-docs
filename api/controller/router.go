package routes

import (
	"github.com/gin-gonic/gin"
	commonController "md_docs_api/controller/common/controllers"
)

func Router() *gin.Engine {
	router := gin.Default()
	registerRouteCommon(router)
	return router
}

func registerRouteCommon(router *gin.Engine) {
	common := router.Group((""))
	common.GET("/system-health", commonController.GetSystemHealth)
}
