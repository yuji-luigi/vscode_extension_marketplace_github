variable "owner" {
  description = "GitHub user or organization that owns the extension's repository."
  type        = string
  default     = "yuji-luigi"
}

variable "repository" {
  description = "Repository whose release.yml publishes the extension."
  type        = string
  default     = "goqulient"
}

variable "environment" {
  description = "GitHub environment the publish job runs in; the Marketplace trusted publishing policy names it too."
  type        = string
  default     = "marketplace"
}

variable "release_branch" {
  description = "The only branch allowed to deploy to the environment."
  type        = string
  default     = "main"
}

variable "reviewers" {
  description = "GitHub logins who must approve each publish."
  type        = list(string)
  default     = ["yuji-luigi"]
}

variable "can_admins_bypass" {
  description = "Whether repository admins may skip the approval. Set false so even an admin publish waits for review."
  type        = bool
  default     = true
}
