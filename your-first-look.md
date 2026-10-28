# Your First Look

Outcome: standing in any repository, you
can get act to show you every workflow it
found, the jobs inside them, and the
order those jobs would run in — no
downloads, no containers, nothing run.

## The lab project

Every example in this guide uses the tiny
project in `act-lab/project/`: a shell
script that counts lines and words in a
text file, its test script, and two
workflow files. Copy it anywhere, make it
a git repository (`git init`, one commit
— act reads branch and commit from git
when it can), and the commands below
behave exactly as the transcripts show.

## Listing what act found

```bash
act --list
```

Transcript t02:

```text
Stage  Job ID   Job name  Workflow name  Workflow file  Events
0      test     test      CI             ci.yml         push
0      greet    greet     Greet          greet.yml      workflow_dispatch
1      package  package   CI             ci.yml         push
```

Read it as a table of *jobs*, not files:
one row per job, with the workflow it
lives in, the file it came from, and the
events that trigger it. The **stage**
column is the running order act computed
from `needs:` — stage 0 jobs can start
immediately and in parallel; a stage 1
job starts only when every job it needs
has finished. `package` sits in stage 1
because `ci.yml` says `needs: test`.

Two habits worth forming here:

- The list is per *working directory*. Run
  it in the wrong folder and you list the
  wrong project — or get an error that no
  workflows were found. `act -W path/to/
  workflows` points at another folder of
  workflow files when you need to.
- The first line of output, on a machine
  where act can reach Docker, is a note
  about the Docker host. It appears even
  for planner commands; it does not mean
  anything was pulled or started.

## Asking about one job

```bash
act --list --job test
```

Narrows the table to the one job
(transcript t03) — useful in repositories
whose full list runs to screens. The
matching `--job` filter works on runs
too: it is how you re-run a single failed
job instead of the whole workflow.

## Drawing the plan

```bash
act --graph
```

Transcript t03 again, with the terminal's
colour codes removed:

```text
 ╭──────╮ ╭───────╮
 │ test │ │ greet │
 ╰──────╯ ╰───────╯
         ⬇
    ╭─────────╮
    │ package │
    ╰─────────╯
```

The same information as the table, drawn
as boxes and arrows: `test` and `greet`
side by side, `package` hanging below
`test` on the arrow its `needs:` makes.
In a repository with one small workflow
this is decoration; in one with twenty
jobs and a web of `needs:`, it is the
fastest way to see the shape of a run —
and to spot the job that is *not*
connected the way its author assumed.

## What this chapter's commands cost

Nothing: no image is pulled, no container
is created, and the Docker daemon is only
asked where it lives. That is worth
knowing in both directions. These
commands are safe to run anywhere,
including in scripts that check a
repository's shape. And their success
proves only that act can *read* your
workflows — the first command that needs
Docker for real is a run, and the first
command that needs an image is chapter
5's question away.

Check: in the lab project, `act --list`
shows three jobs in two stages, and
`act --graph` puts `package` under
`test`. If your list shows a job in the
wrong stage, the `needs:` lines in the
workflow are the place to look — the
planner believes them completely.
