# GitHub side of publishing a VS Code extension with Marketplace trusted publishing (OIDC). The Marketplace side
# (the trusted publishing policy) has no Terraform provider or public API: see README.md.

data "github_user" "reviewer" {
  for_each = toset(var.reviewers)
  username = each.value
}

# The publish job in release.yml runs in this environment: only the release branch may deploy, and a reviewer approves
# every run. The Marketplace policy names the environment, so tokens from anywhere else are refused.
resource "github_repository_environment" "marketplace" {
  repository          = var.repository
  environment         = var.environment
  prevent_self_review = false # a single maintainer must be able to approve their own release
  can_admins_bypass   = var.can_admins_bypass

  reviewers {
    users = [for u in data.github_user.reviewer : tonumber(u.id)]
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "release_branch" {
  repository     = var.repository
  environment    = github_repository_environment.marketplace.environment
  branch_pattern = var.release_branch
}

# release-please opens and updates its release PR with GITHUB_TOKEN: Settings → Actions → General → "Allow GitHub
# Actions to create and approve pull requests". Workflows still get read-only tokens by default.
resource "github_workflow_repository_permissions" "actions" {
  repository                       = var.repository
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = true
}
