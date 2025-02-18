package app

import "md_docs_api/controller"

func Run() {
	router := routes.Router()

	router.Run("0.0.0.0:8088")
}
