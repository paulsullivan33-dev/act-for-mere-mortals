# What act Is

A **GitHub Actions workflow** is a set of
instructions you keep in your repository —
a YAML file under `.github/workflows/` —
that tells GitHub: *when this happens*
(a push, a pull request, a button press),
*run these jobs on a fresh machine*
(install this, run the tests, build the
release). GitHub runs them on computers
it calls **runners**, and until recently
the only way to find out whether a
workflow worked was to push it and watch
the run on the website. A typo cost you a
commit, a push, and a wait, every time.

**act is a program that runs those same
workflows on your own machine.** It reads
the workflow files in your repository,
works out which jobs the event you name
would trigger, and runs each job inside a
**Docker container** — a disposable,
isolated Linux environment — that stands
in for a GitHub runner. The steps run in
order, the log prints in your terminal,
and the exit code tells you whether the
job passed, all before anything leaves
your desk.

That one idea — *the same file, a local
stand-in runner* — is the whole tool.
Everything else in this guide is detail
about how good the stand-in is, and where
it stops resembling the real thing.

## Why anyone would do this

- **Faster feedback.** Editing a workflow
  on GitHub's website-by-push is a slow
  loop: commit, push, wait for a runner,
  read the log, repeat. Locally the loop
  is edit, run, read — seconds for the
  plan, and no queue.
- **Debugging with your hands on it.**
  When a step fails on GitHub you get a
  log and a guess. Locally you can re-run
  one job, keep the container afterwards,
  and poke at the scene of the failure.
- **Your CI, off the clock.** Experiments,
  drafts, and "I wonder if this works"
  runs do not spend your GitHub Actions
  minutes or fill the repository's run
  history with noise.
- **Learning Actions itself.** A workflow
  you can list, draw, and dry-run locally
  is a workflow you can take apart.
  Chapters 4 and 6 of this guide are
  mostly that: reading the plan act makes
  before it runs anything.

## A first taste

After installing (chapter 3), stand in a
repository that has workflows and ask act
what it sees:

```bash
act --list
```

The lab's answer, from transcript
`act-lab/transcripts/t02-list.txt`:

```text
Stage  Job ID   Job name  Workflow name  Workflow file  Events
0      test     test      CI             ci.yml         push
0      greet    greet     Greet          greet.yml      workflow_dispatch
1      package  package   CI             ci.yml         push
```

Two workflow files, three jobs. `test`
and `greet` can start at once (stage 0);
`package` waits for `test`, because the
workflow says `needs: test` (stage 1).
No containers were started and nothing
was downloaded to produce that table —
act had only to read the files. Much of
this guide lives at that level, on
purpose: the plan is the part you can
fully trust, and learning to read it is
most of the skill.

## An honest note about this guide's lab

The lab ran the real thing: **act
0.2.92**, downloaded from the project's
own releases and checksum-verified, and a
real Docker daemon (29.1.3) that could
pull images from both Docker Hub and
GitHub's container registry. The lab
listed, graphed, validated, and dry-ran
its workflows, answered act's first-run
question, and started two real runs.

Both real runs stopped at the same wall,
and the wall was the lab machine, not
act: this build machine is itself a
restricted sandbox, and it will not let
*any* container start — chapter 8 shows
plain `docker run hello-world` failing
with the same class of error that stopped
act's job container. So the chapters
about steps actually executing inside a
container are taught from act's verified
plan — the dry run prints the exact
Docker commands act will issue, and the
lab captured them — together with the
project's documentation, and they are
labelled documented-only wherever they
appear. `criteria.md` keeps the full
ledger of what was run and what was only
read. On an ordinary machine with a
working Docker, the runs in chapter 8
continue past the point where the lab's
stopped.

## Who it is for

The developer whose workflow fails on
GitHub for reasons the web log makes
mysterious. The maintainer who edits
workflows often enough that the push-and-
wait loop hurts. The student of CI who
wants to see the machinery — event, plan,
container, step — without spending
anyone's minutes. The common thread is a
workflow file, a machine with Docker, and
a wish to know *before* pushing.

## What it is not

act is not GitHub. It imitates the runner
environment with a container image, and
the imitation is good enough to catch
most workflow mistakes early — but hosted
features with no local counterpart (the
cloud cache service, the artifact store
behind a web page, GitHub's own token
permissions) are approximated or absent,
and chapter 14 states the gaps plainly.
It is also not a general task runner: if
what you want is "run these commands when
I type `make test`", that is Make's
country (chapter 13), and no workflow
file is required. And it is not a way to
run other people's workflows carelessly:
a workflow is code, and act runs it with
your Docker daemon's powers — chapter 2
says what that means before you are asked
to run anything.
