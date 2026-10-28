# Choosing Images

Outcome: you can point any platform a
workflow names — `ubuntu-latest`,
`ubuntu-22.04`, and friends — at any
container image, for one run or for
good, and you understand the trade you
are making each time.

## The mapping is the mechanism

A workflow says `runs-on: ubuntu-latest`.
It does not say which machine image that
is — on GitHub it means "the current
Ubuntu runner image", and locally the
meaning is whatever act's **platform
mapping** says. The mapping is set with
`-P platform=image`, and it is the single
most useful knob act has:

```bash
act push -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
```

That is the exact command of the lab's
second real run (transcript t07): the
same image GitHub's registry mirrors,
used because Docker Hub had just cut a
connection mid-pull (chapter 8). Nothing
else about the run changed — the plan,
the jobs, the steps — only where the
stand-in machine comes from.

## The three sizes, and what they cost

Chapter 5's question offered three
defaults, and each is a different answer
to "how close to GitHub's runner do you
need to be?":

- **Large** (`catthehacker/ubuntu:
  act-latest` and its dated siblings, in
  the project's *full* line) — a snapshot
  of the real runners: roughly a 17 GB
  download and 53 GB stored. For
  workflows that quietly assume some tool
  GitHub pre-installs. Brutal on a small
  disk.
- **Medium** (the same image names used
  with the *runner* tooling trimmed — the
  set the first-run answer writes, about
  500 MB to download) — carries what most
  actions need to bootstrap themselves,
  and installs the rest when steps ask.
  The lab's actrc points every Ubuntu
  platform at this line.
- **Micro** (the project's `node:16`
  images, under 200 MB) — little more
  than Node.js, enough for JavaScript
  actions and nothing else. A workflow
  whose steps run shell commands or
  expect common tools will fail in a
  micro image for reasons that look like
  workflow bugs and are not.

Sizes quoted are the ones act itself
printed at the question (transcript t04).
The lab verified the medium GHCR image's
download at 1.63 GB once stored locally —
"ca. 500 MB" is the compressed pull, and
chapter 15 lists disk as a real
constraint for small machines.

## Any image can stand in

Nothing about `-P` limits you to
catthehacker's images. A workflow whose
steps are plain shell often runs happily
in a small general image:

```bash
act push -P ubuntu-latest=node:16-buster-slim
```

The lab pulled that image from Docker
Hub without trouble while composing this
chapter's notes — it just could not
start it, like every container on that
machine (chapter 8). The principle
stands and is worth stating: **the image
is the machine.** Its tools are the
tools your steps get; its package
manager is how missing ones arrive; its
age is your reproducibility. Teams that
use act seriously often end up building
their own runner image — the workflow's
`runs-on` pointed at a picture of a
machine they control — which is the
mapping used exactly as designed.

Windows and macOS platforms are the hard
edge: a workflow asking for
`windows-latest` or `macos-latest` cannot
be satisfied by any Linux container
image. act will tell you no image is
mapped for the platform; mapping one
anyway gives the job a Linux machine
wearing a false name, and steps that use
Windows tooling fail inside it. Those
workflows are simply outside act's
reach — chapter 14 counts them as a
limit, not a puzzle.

## Making a mapping stick

A `-P` on the command line lasts one run.
The same line, without the word `act`,
belongs in an `actrc` file — your user
one at `~/.config/act/actrc`, or the
project's `.actrc`, which is where the
lab kept its GHCR mapping:

```text
-P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
```

Transcript t15 shows a dry run with no
`-P` flag picking that line up and
planning around the GHCR image. Chapter
11 is about those files, including which
one wins when they disagree (the
command line beats both files; the
project file is read after the user
file) and the trust rule that governs
what a project's `.actrc` is allowed to
ask for.

## Pulling behaviour

By default act asks the daemon to pull
the image on **every** run
(`forcePull=true` in the plan lines of
t05 and t07), so a re-tagged image never
goes stale quietly. On a slow connection
that is real time spent re-fetching;
`--pull=false` — or `--action-offline-
mode` for actions — trades freshness for
speed once you trust your local copies.

Check: `act --dryrun push -P
ubuntu-latest=node:16-buster-slim` shows
`Start image=node:16-buster-slim` in the
plan without downloading anything — the
mapping is visible in the plan before it
costs a byte.
