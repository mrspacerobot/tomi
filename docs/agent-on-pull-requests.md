# Asking the agent from GitHub

Write `@claude` followed by what you want in a pull request comment, a review, or an issue comment. An agent picks it up on the owner's Mac, makes the change, runs `./scripts/check.sh`, pushes to that pull request's branch, and replies in the thread.

```
@claude the stamp is too small on the menu, make it match the mockup
```

## Several requests in one review

Put `@claude` in as many inline comments as you like and submit them as one review. The agent gets all of them in one run, each with its file and line, and answers with a checklist in a single comment on the pull request: one ticked line per request saying what changed, or why it did not.

A single inline comment or a reply in a thread works the same way, as a review with one request. An inline comment without `@claude` is left alone.

## The pull request description

Every pull request uses [the shared Markdown template](../.github/pull_request_template.md). Keep the headings and their order, complete each section, and remove its instructional comments and placeholders. Keep the description current after follow-up changes, including validation results and screenshots. The comment answering review requests is still a checklist; it does not replace the description.

When creating a pull request with a CLI or API, explicitly read the template and fill it into a temporary Markdown file. Pass the completed file with `gh pr create --body-file <path>` (or the equivalent body argument for the client). The GitHub web form can insert the template, but agents must not rely on a CLI or API doing so.

## Screenshots for UI tasks

A UI task includes changes to screens, navigation, components, design tokens, illustrations or visible text. Embed screenshots of each changed screen or meaningful state in the description's Screenshots section. Capture the working app from the final code in both light and dark mode, with fake data. For shared components or tokens, use the running component gallery or a representative screen that exercises the change. For flows, reach the changed state by using the app as a cook would.

1. Build and run the branch in the simulator or on a device. Navigate to the changed screen with fake data, then exercise the changed behavior. Compare it with the approved mockup.
2. Capture light and dark screenshots after the screen has settled in each appearance. For a simulator, use its device identifier rather than `booted` when several simulators are running:

   ```sh
   xcrun simctl ui <device-identifier> appearance light
   xcrun simctl io <device-identifier> screenshot <screen>-light.png
   xcrun simctl ui <device-identifier> appearance dark
   xcrun simctl io <device-identifier> screenshot <screen>-dark.png
   ```

3. Post the images so the owner can see them directly in the pull request. Use GitHub image attachments when available. If the agent cannot upload attachments, commit the captures under `docs/pr-screenshots/<issue-number>/` on the issue branch and embed each with a URL of this form, replacing every placeholder:

   ```md
   ![Screen and state, iPhone model, iOS version, light, text size](https://github.com/mrspacerobot/tomi/blob/<commit-sha>/docs/pr-screenshots/<issue-number>/<screen>-light.png?raw=true)
   ```

4. Open the pull request and verify that the images render. Label each screen/state, device, iOS version, appearance and text size, and record how to reach it in Validation. Include the relevant mockup reference. Check small and large phones and the largest Dynamic Type size as required by the implementation plan; include extra captures when they show layout behavior the standard pair does not.

Screenshots must come from the running app, not a mockup, generated image or SwiftUI preview. Refresh them after any revision that changes what they show. Local paths and test-result bundles alone are not posted pictures. If capture or posting is blocked, explain why and leave the pull request in draft until the evidence is available. For changes with no UI effect, keep the Screenshots heading and write "Not applicable - no UI changes."

## How it works

1. A comment or a submitted review starts the workflow in `.github/workflows/claude.yml`. Workflows started this way always run the version on `main`.
2. A short first job on GitHub's own machine checks that the owner wrote it and collects every request that names `@claude`. If there is none, nothing else runs and the Mac is not woken.
3. GitHub hands the work to the self-hosted runner on the owner's Mac (label `tomi-mac`), because building and testing an iPhone app needs Xcode and the simulator.
4. Claude Code runs there, reads `AGENTS.md`, and follows it. It never merges and never pushes to `main`.

The Mac runs one job at a time. If it is busy, off or asleep, jobs wait in the queue and run in order when it is free. This relies on there being exactly one runner with the `tomi-mac` label: with two, two agents could push to the same branch at once.

## The check on every pull request

The same runner also runs `./scripts/check.sh` on every pull request to `main` (`.github/workflows/check.yml`). It costs nothing, because a self-hosted runner uses no GitHub minutes.

- It runs when a pull request is opened and on every push to it. A new push cancels the older run of that pull request.
- It shares the one runner with the agent, so a check and an agent job never run at the same time: one waits for the other.
- It only runs while the Mac is awake. Until then the check shows as waiting on the pull request.
- It skips pull requests from forks, so nobody else's code runs on the Mac.
- GitHub cannot require it before a merge on this plan. The owner merges only when it is green.

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
