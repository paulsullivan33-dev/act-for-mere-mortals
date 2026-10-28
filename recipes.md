# Recipes

Short, complete procedures. Each names
what it proves and the chapter it leans
on. Commands verified in the lab say so;
the ones that end inside a running
container are marked documented, for the
reason chapter 8 explains.

## Check a workflow edit before pushing it

```bash
act --validate && act --list
```

Verified (chapters 6). Catches malformed
YAML and shows the plan your edit
produces, in seconds, with no commit.
Make it a habit between saving the file
and `git push` — it will not catch
everything (chapter 6's missing
`runs-on`), but it catches the most
embarrassing class completely.

## Re-run only the job that failed

```bash
act push --job test
```

The `--job` filter works for listing
(chapter 4) and running alike. On a real
run (documented tail), follow it with
`--reuse` and inspect the kept container:

```bash
act push --job test --reuse
docker ps            # find the job container
docker exec -it <container> /bin/bash
```

That is the debugging loop GitHub cannot
give you: fail, step inside the machine
that failed, look around, fix, re-run.

## Try someone else's workflow safely-ish

```bash
act --list -W their-repo/.github/workflows
act --dryrun push -W their-repo/.github/workflows
```

Listing and dry-running read files and
run nothing (chapters 4 and 6) — the
safe way to see what a workflow *would*
do before deciding whether it earns a
real run. Read the workflow first in any
case, and remember the project `.actrc`
trust rule (chapter 11) before running
act inside their checkout.

## Run the manual workflow with its inputs

```bash
act workflow_dispatch --input name=World --input loud=true
```

Verified as a plan (chapter 10,
transcript t09). The local equivalent of
GitHub's "Run workflow" form, and the
fastest way to exercise the dispatch-only
paths of a workflow that push never
triggers.

## Feed a workflow the event it expects

```bash
act push --eventpath push-event.json --actor octocat
```

Verified as a plan (transcript t10).
Capture a real payload from a past
GitHub run's event data when a workflow
branches on fields a bare `act push`
cannot invent — the sender, the exact
ref, the head commit's message — and the
local run stands for *that* push, not a
generic one.

## Pin a project to a registry it can reach

```text
# .actrc, in the repository
-P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
```

Verified (chapter 9, transcript t15).
One line in the project's `.actrc` and
every contributor's runs use the
reachable registry, instead of each
person re-discovering a blocked or
failing one.

## Test the code on your disk, not the last commit

No command needed — this is act's
default checkout behaviour (chapter 8):
the working directory is copied in,
uncommitted changes included. Edit,
`act push`, see the result, *then*
commit what passed. It inverts the usual
order, and for workflow-driven tests it
is the better one.

## Keep a record of what a run did

```bash
act push --json > run.json
act push --verbose   # when the plain log is not enough
```

Both flags exist and are listed in
`act --help` (transcript t00); the JSON
log is the one to archive when a local
run's result will be quoted at someone.
Marked documented — the lab's runs ended
before a log worth archiving could form.
