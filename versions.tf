terraform {
  required_version = ">= 1.5" # import blocks

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6"
    }
  }
}

# Authentication: GITHUB_TOKEN in the environment (e.g. `GITHUB_TOKEN=$(gh auth token)`), never in a file.
provider "github" {
  owner = var.owner
}
