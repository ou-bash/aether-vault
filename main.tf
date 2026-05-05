terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "aether_network" {
  name = "aether-network-tf"
}

resource "docker_container" "nginx_proxy" {
  name  = "nginx-proxy-tf"
  image = "jc21/nginx-proxy-manager:latest"
  restart = "unless-stopped"

  ports {
    internal = 80
    external = 80 
}
  ports { 
    internal = 81
    external = 81 
}
  ports { 
    internal = 443
    external = 443 
}

  volumes {
    host_path      = "${var.project_root}/nginx/data"
    container_path = "/data"
  }
  volumes {
    host_path      = "${var.project_root}/nginx/letsencrypt"
    container_path = "/etc/letsencrypt"
  }

  networks_advanced {
    name = docker_network.aether_network.name
  }
}

resource "docker_container" "aethervault" {
  name  = "aethervault-terraform"
  image = "filebrowser/filebrowser:latest"
  user  = var.user_mapping

  ports {
    internal = 80
    external = 8080 
  }

  volumes {
    host_path      = "${var.project_root}/files"
    container_path = "/srv"
  }

  volumes {
    host_path      = "${var.project_root}/database/filebrowser.db"
    container_path = "/database/filebrowser.db"
  }

  networks_advanced {
    name = docker_network.aether_network.name
  }

  restart = "unless-stopped"
}


# 1. cAdvisor (The Container Watcher)
resource "docker_container" "cadvisor" {
  name  = "cadvisor"
  image = "gcr.io/cadvisor/cadvisor:latest"
  restart = "unless-stopped"
  
  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }
  volumes {
    host_path      = "/var/run"
    container_path = "/var/run"
    read_only      = true
  }
  volumes {
    host_path      = "/sys"
    container_path = "/sys"
    read_only      = true
  }
  volumes {
    host_path      = "/var/lib/docker"
    container_path = "/var/lib/docker"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.aether_network.name
  }
}

# 2. Prometheus (The Metrics Database)
resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = "prom/prometheus:latest"
  restart = "unless-stopped"

  volumes {
    host_path      = "${var.project_root}/monitoring/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }

  networks_advanced {
    name = docker_network.aether_network.name
  }
}

# 3. Grafana (The Dashboard)
resource "docker_container" "grafana" {
  name  = "grafana"
  image = "grafana/grafana:latest"
  restart = "unless-stopped"

  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.aether_network.name
  }
}


# 4. Loki (The Log Database)
resource "docker_container" "loki" {
  name  = "loki"
  image = "grafana/loki:latest"
  restart = "unless-stopped"
  
  # Loki uses a default config inside the image, but we can just start it
  networks_advanced { name = docker_network.aether_network.name }
}

# 5. Promtail (The Log Collector)
resource "docker_container" "promtail" {
  name  = "promtail"
  image = "grafana/promtail:latest"
  restart = "unless-stopped"

  volumes {
    host_path      = "${var.project_root}/monitoring/promtail.yml"
    container_path = "/etc/promtail/config.yml"
  }
  # This allows Promtail to read your actual Docker container logs
  volumes {
    host_path      = "/var/lib/docker/containers"
    container_path = "/var/lib/docker/containers"
    read_only      = true
  }
  # Needed for log metadata
  volumes {
    host_path      = "/var/log"
    container_path = "/var/log"
    read_only      = true
  }

  networks_advanced { name = docker_network.aether_network.name }
}
