# Glossary

The terms, collected in one place. Each
is defined where it first appears, too.

**Action** — a reusable bundle of code a
step can invoke with `uses:`, such as
`actions/checkout@v4`. Written in
JavaScript, as a Docker container, or as
a composite of other steps.

**actrc** — a file of act flags, one per
line. Yours lives at `~/.config/act/
actrc`; a project may carry its own
`.actrc`, which a trust rule limits
(chapter 11).

**Artifact** — files a job saves for
later jobs or for download. On GitHub a
hosted service; under act, a local
server standing in for it.

**Cache server** — act's local stand-in
for GitHub's cache service, used by
actions that cache dependencies between
runs.

**Container** — a disposable, isolated
Linux environment created from an image.
act runs each job in one; Docker manages
them.

**Context** — the values a workflow's
expressions can read mid-run:
`${{ github.* }}`, `${{ inputs.* }}`,
`${{ secrets.* }}`, `${{ vars.* }}`, and
more.

**Daemon** — the background Docker
service that pulls images and creates,
starts, and removes containers on act's
instructions.

**Dry run** — `act --dryrun` (or `-n`):
act builds and prints the full plan for
an event and performs none of it
(chapter 6).

**Event** — the named happening that
triggers workflows: `push`,
`pull_request`, `workflow_dispatch`,
and others. The first word of an act
command is usually the event.

**Event payload** — the JSON document
describing an event (the ref pushed,
the sender, the head commit). GitHub
delivers it with the event; locally,
`--eventpath` supplies it from a file.

**Image** — a prebuilt filesystem
snapshot a container starts from. act
maps each `runs-on:` platform to one.

**Input** — a value a `workflow_dispatch`
workflow declares and its invoker
supplies — a form field on GitHub, a
`--input` flag under act.

**Job** — one entry under `jobs:` in a
workflow: a list of steps, run on one
runner (one container, under act).

**Needs** — a job's declaration of which
other jobs must finish first. act reads
it to build the stages in its plan.

**Platform** — the name after `runs-on:`
(`ubuntu-latest`, `ubuntu-22.04`, …).
Locally, a key in act's image mapping.

**Platform mapping** — the `-P
platform=image` settings that decide
which container image stands in for each
platform (chapter 9).

**Planner** — the part of act that reads
workflow files, selects jobs for an
event, orders them by `needs:`, and
answers `--list`, `--graph`,
`--validate`, and `--dryrun` without
Docker.

**Runner** — the machine a job executes
on. GitHub's are hosted and real; act's
are containers standing in.

**Secret** — a named credential supplied
from outside the repository and read as
`${{ secrets.NAME }}`. Under act, passed
by `--secret` or a `.secrets` file, and
masked in the log.

**Stage** — the group of jobs that can
start together, as computed from
`needs:` and shown in `act --list`.

**Step** — one `uses:` or `run:` item in
a job. Steps run in order and share the
job's container and filesystem.

**Workflow** — one YAML file in
`.github/workflows/`: the events it
answers and the jobs it defines.

**workflow_dispatch** — the manual
event: a workflow run by a person
pressing a button (or naming the event
to act), optionally with inputs.
