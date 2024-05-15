provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

resource "kubernetes_deployment" "hola-mundo" {
  metadata {
    name = "api"
    labels = {
      App = "scalable-mundo"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "scalable-mundo"
      }
    }
    template {
      metadata {
        labels = {
          App = "scalable-mundo"
        }
      }
      spec {
        container {
          image = "danielvh01/api:latest"
          name  = "example"

          port {
            container_port = 3030
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hola-mundo" {
  metadata {
    name = "hola-mundo"
  }
  spec {
    selector = {
      App = kubernetes_deployment.hola-mundo.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30208
      port        = 3030
      target_port = 3030
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "mongodb" {
  metadata {
    name = "mongodb"
    labels = {
      App = "MongoDB"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "MongoDB"
      }
    }
    template {
      metadata {
        labels = {
          App = "MongoDB"
        }
      }
      spec {
        container {
          image = "mongo:latest"
          name  = "mongodb"

          port {
            container_port = 27017
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongodb" {
  metadata {
    name = "mongodb"
  }
  spec {
    selector = {
      App = kubernetes_deployment.mongodb.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30205
      port        = 27017
      target_port = 27017
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "apache" {
  metadata {
    name = "apache"
    labels = {
      App = "Apache"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "Apache"
      }
    }
    template {
      metadata {
        labels = {
          App = "Apache"
        }
      }
      spec {
        container {
          image = "httpd:latest"
          name  = "apache"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "apache" {
  metadata {
    name = "apache"
  }
  spec {
    selector = {
      App = kubernetes_deployment.apache.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30204
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "nginx:1.25.3"
          name  = "api-hello"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}