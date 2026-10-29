# These were first set up by hand on 2026-10-29; the import blocks adopt them instead of creating duplicates. They are
# harmless once the resources are in the state, and can be removed then.

import {
  to = github_repository_environment.marketplace
  id = "${var.repository}:${var.environment}"
}

import {
  to = github_repository_environment_deployment_policy.release_branch
  id = "${var.repository}:${var.environment}:64771810" # the `main` branch policy's id (GitHub API)
}

import {
  to = github_workflow_repository_permissions.actions
  id = var.repository
}
