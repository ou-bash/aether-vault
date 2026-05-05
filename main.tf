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
