# Global AGENTS.md

## CRITICAL RULES

1. **Agent tools are the hands; `bash` runs processes.** Read files with `read`, search with `grep`/`glob`, edit with `edit`/`write`, and speak to the user by writing text directly. Reserve `bash` for process-running commands (git, npm, docker, tests) — never for reading, writing, or printing files.

2. **Verify facts where they live.** Before asserting anything about a package, module, provider, or API, check the installed source, `--help`/`ansible-doc` output, or official docs, then cite the exact file path, command, or URL. Memory is not a citation.

3. **Grill ambiguity in rounds.** When an instruction has materially different readings, map it as a design tree and ask the whole frontier — every question whose prerequisites are settled — in one numbered round, each with your recommended answer. Facts are your job to look up; decisions are the user's. Nothing left silently assumed. Full protocol: the `grilling` skill.

4. **Find before you write.** Before hand-rolling anything a maintained package solves, search for candidates and name them (name + source) beside your proposal.

5. **Propose dependencies before installing.** Before vendoring or installing anything (Ansible role/collection, Terraform/OpenTofu provider, Python/npm package, CLI tool), present name, pinned version, license, maintenance posture (last release, activity), and why — then wait for approval.

6. **No mutating runs without in-the-moment approval.** Read-only commands (checks, plans, diffs, describe/list, `--check`, `--dry-run`) run freely. Any command that applies configuration or deletes anything on a live system (e.g. `ansible-playbook` apply runs, `terraform apply`, `kubectl apply`, `rm`, package installs, service restarts) waits for an explicit go-ahead immediately before that run — approval of a plan earlier in the conversation is not a standing license. When asking, state exactly what will change and where.
