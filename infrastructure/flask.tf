# TODO: Replace <your-org> with your team's GitHub organization or username
# Example: ghcr.io/team-github-org/flask-app:latest or ghcr.io/studentname/flask-app:latest

resource "kubernetes_deployment" "flask" {
  metadata {
    name      = "flask"
    namespace = "default"
    labels = {
      app = "flask"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "flask"
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "1"
        max_unavailable = "0"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }
      }

      spec {
        container {
          name  = "flask"
          image = "ghcr.io/<your-org>/flask-app:latest"

          env_from {
            secret_ref {
              name = "flask-credentials"
            }
          }

          port {
            container_port = 5000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask" {
  metadata {
    name      = "flask"
    namespace = "default"
  }

  spec {
    selector = {
      app = "flask"
    }

    port {
      port        = 80
      target_port = 5000
    }
  }
}
