package models

type SystemHealthStatus string

const (
	SystemRunning SystemHealthStatus = "running"
	SystemError   SystemHealthStatus = "stoped"
)

type SystemHealth struct {
	Status SystemHealthStatus `json:"status"`
}
