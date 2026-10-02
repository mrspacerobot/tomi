# Asking the agent from GitHub

Write `@claude` followed by what you want in a pull request comment, a review, or an issue comment. An agent picks it up on the owner's Mac, makes the change, runs `./scripts/check.sh`, pushes to that pull request's branch, and replies in the thread.

```
@claude the stamp is too small on the menu, make it match the mockup
```

## How it works

1. The comment starts the workflow in `.github/workflows/claude.yml`. Workflows started by comments always run the version on `main`.
2. The workflow only continues if the comment was written by the owner and contains `@claude`.
3. GitHub hands the job to the self-hosted runner on the owner's Mac (label `tomi-mac`), because building and testing an iPhone app needs Xcode and the simulator.
4. Claude Code runs there, reads `AGENTS.md`, and follows it. It never merges and never pushes to `main`.

If the Mac is off or asleep, the job waits in the queue until it is back.

## One-time setup

1. **Install the Claude GitHub app** on this repository: https://github.com/apps/claude
2. **Add the secret.** In the Terminal app:
   ```
   claude setup-token
   gh secret set CLAUDE_CODE_OAUTH_TOKEN -R mrspacerobot/tomi
   ```
   The first command prints a token after you sign in. The second asks you to paste it.
3. **Register the Mac as a runner.** On GitHub: Settings > Actions > Runners > New self-hosted runner > macOS, ARM64. Run the commands it shows in the Terminal app, from a new folder `~/actions-runner-tomi`. When asked for labels, enter `tomi-mac`.
4. **Keep it running in the background:**
   ```
   cd ~/actions-runner-tomi
   ./svc.sh install
   ./svc.sh start
   ```

## Day to day

| To | Run in `~/actions-runner-tomi` |
|---|---|
| See if the runner is up | `./svc.sh status` |
| Pause it | `./svc.sh stop` |
| Resume it | `./svc.sh start` |
| Remove it for good | `./svc.sh uninstall`, then remove the runner on GitHub under Settings > Actions > Runners |

## Safety

- The repository is private. Never attach a self-hosted runner to a public repository: anyone could then run code on the Mac.
- Jobs run as the owner's user account, so the agent can reach what that account can reach. The workflow limits it to the owner's own comments and to build and test commands.
- GitHub cannot protect `main` on this plan. The rule in `AGENTS.md` and the blocked commands in the workflow are the guard.
