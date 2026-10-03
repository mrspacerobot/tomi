# Asking the agent from GitHub

Write `@claude` followed by what you want in a pull request comment, a review, or an issue comment. An agent picks it up on the owner's Mac, makes the change, runs `./scripts/check.sh`, pushes to that pull request's branch, and replies in the thread.

```
@claude the stamp is too small on the menu, make it match the mockup
```

## Several requests in one review

Put `@claude` in as many inline comments as you like and submit them as one review. The agent gets all of them in one run, each with its file and line, and answers with a checklist in a single comment on the pull request: one ticked line per request saying what changed, or why it did not.

A single inline comment or a reply in a thread works the same way, as a review with one request. An inline comment without `@claude` is left alone.

## How it works

1. A comment or a submitted review starts the workflow in `.github/workflows/claude.yml`. Workflows started this way always run the version on `main`.
2. A short first job on GitHub's own machine checks that the owner wrote it and collects every request that names `@claude`. If there is none, nothing else runs and the Mac is not woken.
3. GitHub hands the work to the self-hosted runner on the owner's Mac (label `tomi-mac`), because building and testing an iPhone app needs Xcode and the simulator.
4. Claude Code runs there, reads `AGENTS.md`, and follows it. It never merges and never pushes to `main`.

The Mac runs one job at a time. If it is busy, off or asleep, jobs wait in the queue and run in order when it is free. This relies on there being exactly one runner with the `tomi-mac` label: with two, two agents could push to the same branch at once.

## One-time setup

1. **Add the secret.** In the Terminal app:
   ```
   claude setup-token
   gh secret set CLAUDE_CODE_OAUTH_TOKEN -R mrspacerobot/tomi
   ```
   The first command prints a token after you sign in. The second asks you to paste it.
2. **Register the Mac as a runner.** On GitHub: Settings > Actions > Runners > New self-hosted runner > macOS, ARM64. Run the commands it shows in the Terminal app, from a new folder `~/actions-runner-tomi`. When asked for labels, enter `tomi-mac`.
3. **Keep it running in the background:**
   ```
   cd ~/actions-runner-tomi
   ./svc.sh install
   ./svc.sh start
   ```

No GitHub app is installed. The workflow uses its own built-in token, so the agent's commits and replies appear as `github-actions`.

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
