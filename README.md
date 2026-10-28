# act for Mere Mortals

A GitHub Actions workflow is a promise
you make in YAML: *when this is pushed,
run my tests on a fresh machine.* Keeping
the promise used to mean pushing and
waiting — every typo cost a commit, a
run, and a queue. **act** is a program
that keeps the promise at home. It reads
the workflow files in your repository,
works out which jobs an event would
trigger, and runs each one in a **Docker
container** that stands in for a GitHub
**runner**: same file, same steps, your
machine, your terminal, seconds instead
of a queue.

This guide explains how that works: how
to read the plan act makes before it runs
anything, what to do about the question
it asks before its first run, how to dry
-run and validate a workflow before
pushing it, how the runner **images** are
chosen and changed, and how events,
inputs, and secrets are fed to a local
run. The limits are stated plainly,
including the verified one: act's
validation is shallower than GitHub's,
and a local green light is a rehearsal,
not a verdict.

One caution governs the tool, stated in
chapter 2 and repeated where it matters:
a workflow is **code**, and act runs it
with your Docker daemon's powers. Read
workflows — especially other people's —
before you run them.

The lab behind this guide ran the real
thing: **act 0.2.92**, installed from the
project's own release tarball with its
checksum verified, against a deliberately
tiny project (a word-count script, its
test, and two small workflows, all in
`act-lab/project/`). Against it the lab
listed and graphed the workflows,
answered the first-run image question,
captured complete dry-run plans for a
push and a manual dispatch, validated
good and broken workflow files — and
found a broken one (a job with no
`runs-on:`) that act's validator waves
through — fed a run from an event
payload file, kept an invented secret
out of act's output, configured image
mappings in both actrc files, and
started two real runs.

What the lab could not do, it did not
fake. Its machine is a restricted
sandbox whose Docker can pull images
but cannot start any container at all —
proven with plain `docker run
hello-world`, no act involved — so both
real runs stopped at the container's
door, at two different and instructive
layers. The chapters about steps
executing inside a container are
therefore taught from the verified
dry-run plan (which prints the exact
Docker commands act issues) and the
project's documentation, and are labelled
documented-only wherever they appear.
On an ordinary machine with working
Docker, those runs continue past the
point where the lab's stopped.
`criteria.md` keeps the full ledger.

## What this guide covers

- [**What act is**](what-act-is.md) —
  the mental model: your workflow file, a
  local stand-in runner, and why the plan
  is the part you can fully trust
- [**The moving parts**](the-moving-parts.md) —
  workflow files, the planner, the event,
  the images, Docker, and the stand-ins
  for GitHub's services
- [**Installing act**](installing-act.md) —
  the checksum-verified release tarball,
  the Docker check that comes first, and
  the surprise waiting at first run
- [**Your first look**](your-first-look.md) —
  `act --list` and `act --graph`: every
  job act found, its stage, and the shape
  of the run, for free
- [**The first-run question**](the-first-run-question.md) —
  the image-size question, what it writes
  to your actrc, and why it hangs scripts
- [**Dry runs and validation**](dry-runs-and-validation.md) —
  the full plan with nothing performed,
  and a broken workflow validation misses
- [**Running for real**](running-for-real.md) —
  the run command, the log's rhythm, and
  the lab's two real runs, layer by layer
- [**Choosing images**](choosing-images.md) —
  the `-P` mapping, the three image
  sizes, other registries, and any image
  you like as a stand-in machine
- [**Events, inputs and secrets**](events-inputs-and-secrets.md) —
  payload files, dispatch inputs, and
  secrets that never print
- [**Configuration files**](configuration-files.md) —
  both actrc files, the data dotfiles,
  and the trust rule for a project's
  config
- [**Recipes**](recipes.md) — check
  before you push, re-run one job, feed a
  real payload, pin a reachable registry
- [**The neighbours**](the-neighbours.md) —
  GitHub's runners themselves, scratch
  branches, gitlab-ci-local, Make and
  friends, and the plain shell script
- [**Limits**](limits.md) — stand-in
  drift, shallow validation, platforms
  act cannot be, approximated services,
  and the local costs
- [**Troubleshooting**](troubleshooting.md) —
  the silent hang, the daemon that is not
  there, the registry that cut the call,
  the container that cannot start
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Writing GitHub Actions workflows from
nothing — this guide assumes workflow
files exist (or that you are learning to
read them) and teaches running and
checking them locally; the series' own
*GitHub Actions for Mere Mortals* is the
writing companion. Replacing GitHub's
hosted CI for a team — shared runners,
organisation policy, billing — is out;
act is one developer's rehearsal stage.
Running workflows you have not read, on
any machine you care about, is not a
harder chapter of this book; chapter 2
explains why it is a bad idea in itself.

## How to use this guide

Read chapter 1 for the model and chapter
2 before running anything — knowing
which part holds what turns later
surprises into named problems, and
chapter 2 carries the caution about
workflows as code. Do chapters 4 and 5
in one sitting: list a real repository's
workflows, then answer the first-run
question while it is in front of you.
Chapter 6 is the daily habit this guide
most wants to leave you with — validate
and dry-run between editing and pushing.
Chapters 9 to 11 are reference for when
a run needs shaping: a different image,
a particular event, a secret. The lab's
transcripts live in
`act-lab/transcripts/`; its project is
`act-lab/project/` and its deliberately
broken extras are `act-lab/extras/`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [GitHub Actions for Mere Mortals](https://paulsullivan33-dev.github.io/github-actions-for-mere-mortals/)
- [Docker for Mere Mortals](https://paulsullivan33-dev.github.io/docker-for-mere-mortals/)
- [Git for Mere Mortals](https://paulsullivan33-dev.github.io/git-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/act-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/act-for-mere-mortals/blob/main/LICENSE-CODE).
