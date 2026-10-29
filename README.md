# vscode_extension_marketplace_github

Terraform for the GitHub side of publishing the VS Code extension
[GoQulient](https://github.com/yuji-luigi/goqulient) to the Visual Studio Marketplace with **trusted publishing**
(OIDC, no stored token). The release process itself is described in the extension's
[docs/PUBLISHING.md](https://github.com/yuji-luigi/goqulient/blob/main/docs/PUBLISHING.md).

## What it manages
| Resource | Setting |
|---|---|
| `github_repository_environment.marketplace` | Environment `marketplace` in `yuji-luigi/goqulient`: required reviewer `yuji-luigi` (self-review allowed), custom deployment branch policy |
| `github_repository_environment_deployment_policy.release_branch` | Only branch `main` may deploy to `marketplace` |
| `github_workflow_repository_permissions.actions` | Workflow tokens read-only by default; GitHub Actions may create and approve pull requests (release-please needs it) |

These were first set up by hand on 2026-10-29; `imports.tf` adopts them into the state instead of creating them again.

## What it doesn't manage (manual)
- **Marketplace trusted publishing policy.** There is no Terraform provider and no public API for it (checked
  2026-10-29). Set it at <https://marketplace.visualstudio.com/manage> → publisher `yuji-luigi` → **Trusted
  Publishing** → Create:

  | Field | Value |
  |---|---|
  | Repository owner | `yuji-luigi` |
  | Repository | `goqulient` |
  | Workflow | `release.yml` |
  | Environment | `marketplace` (must equal `var.environment`) |

  A new policy must be used within the time shown on the page (for a private repository, 48 hours), or it stays
  inactive. If you rename the environment here, change the policy too, or publishing fails at the token exchange.
- **Open VSX** (`OVSX_PAT` secret): not set up yet. When it is, it can be added here as a
  `github_actions_environment_secret` on `marketplace`, with the value passed in from outside, never in a file.
- **Account security:** two-factor authentication on the GitHub account and on the Microsoft account that owns the
  Marketplace publisher.

## Usage
Docker only; nothing to install on the Mac. The token comes from the GitHub CLI and goes through the environment, never
into a file or the command line.
```bash
export GITHUB_TOKEN=$(gh auth token)
tf() { docker run --rm -it -v "$PWD:/tf" -w /tf -e GITHUB_TOKEN hashicorp/terraform:1.13 "$@"; }
tf init
tf plan        # first run: "3 to import, 0 to add, 0 to change, 0 to destroy"
tf apply       # adopts the three resources into terraform.tfstate
```
After the first apply, the import blocks are no-ops; you can delete `imports.tf`.

The state (`terraform.tfstate`) is local and gitignored. It holds no secrets today, but keep it out of git anyway; for
more than one machine, move it to a remote backend.

## Variables
| Name | Default | |
|---|---|---|
| `owner` | `yuji-luigi` | owner of the repository |
| `repository` | `goqulient` | repository whose `release.yml` publishes |
| `environment` | `marketplace` | environment name, also in the Marketplace policy |
| `release_branch` | `main` | the only branch allowed to deploy |
| `reviewers` | `["yuji-luigi"]` | logins who approve each publish |
| `can_admins_bypass` | `true` (current setting) | set `false` so even a repository admin's publish waits for approval |
