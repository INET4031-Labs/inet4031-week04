terraform {
  required_version = ">= 1.0"

  # ASSUMPTION: This lab uses a local backend storing state on disk within the team container.
  # In production, state would be stored in a remote backend (S3, Azure Blob, etc.) with state locking.
  # See Week 4 lab directions Part 1, Step 3 for more details.
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    kubernetes = {
      source  = "opentofu/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
