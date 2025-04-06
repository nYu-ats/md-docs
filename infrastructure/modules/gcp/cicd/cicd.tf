resource "google_artifact_registry_repository" "md-docs-dev-repo" {
  location      = "asia-northeast1"
  repository_id = "md-docs-dev"
  format        = "DOCKER"
}

# TODO GitHubリポジトリの繋ぎ込み
