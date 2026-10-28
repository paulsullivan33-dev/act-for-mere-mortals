# The Moving Parts

Outcome: you can name the six parts of an
act run and say which part holds what, so
that later surprises — a 500 MB download,
a question at first run, a secret that
never prints — have a named home.

## The workflow files

The input. Plain YAML files in
`.github/workflows/` in your repository,
exactly the files GitHub itself reads.
act never edits them. Each file declares
one or more **events** it listens to
(after the `on:` key) and one or more
**jobs** (under `jobs:`), and each job is
a list of **steps**: either `uses:` an
**action** — a reusable, published bundle
of code such as `actions/checkout@v4` —
or `run:` a shell command. Chapter 1's
lab project has two small files, and the
whole guide works on them:

- `ci.yml` — on `push`, a `test` job that
  checks the project out and runs its
  test script, and a `package` job that
  needs `test` and packs a tarball.
- `greet.yml` — on `workflow_dispatch`
  (the manual button), a job that greets
  a name given as an **input**.

Both files live in `act-lab/project/`, so
you can read every line the transcripts
were made from.

## The planner

The part of act that reads the files,
picks the jobs an event triggers, orders
them by their `needs:` into **stages**,
and checks the result is well-formed.
The planner is what answers `--list`,
`--graph`, `--validate`, and `--dryrun`,
and it needs no Docker at all to do it —
chapter 6 lives entirely here. The
planner is also where act's reading of a
workflow can differ from GitHub's, and
chapter 6 shows one verified difference:
a job with no `runs-on:` passes act's
validation untouched, and GitHub would
refuse it.

## The event

A run starts from an **event**: `act
push`, `act pull_request`, `act
workflow_dispatch`. The event decides
which workflows fire and fills in the
**context** — the values a workflow can
read as `${{ github.event_name }}`,
`${{ inputs.name }}`, and friends. On
GitHub the event arrives with a **payload**,
a JSON document describing the push or
the button press. Locally you supply it:
act invents a minimal one, reads your
git repository for the branch and commit,
or takes a real payload from a file with
`--eventpath`. Chapter 10 covers all
three, and shows what the lab could
verify about each.

## The images

Each job names a platform with `runs-on:`
— usually `ubuntu-latest`. A container
needs an **image**: a prebuilt filesystem
snapshot to start from. GitHub's runners
are full machines with hundreds of tools
installed; act substitutes container
images built by the **catthehacker**
project, in three sizes, and the mapping
from `ubuntu-latest` to an image is a
setting you control (`-P`, chapter 9).
This is the part that downloads: the
medium image is roughly 500 MB, and the
large one wants about 75 GB of free disk,
which is why act asks before it pulls —
chapter 5 is that question.

## Docker

act does not run your steps itself. It
asks the **Docker daemon** — the
background service that manages
containers — to pull the image, create a
container from it, copy or mount your
repository inside, and execute the steps
there, streaming the log back. The dry
run in chapter 6 prints those requests
verbatim:

```text
*DRYRUN* [CI/test]   🐳  docker pull image=catthehacker/ubuntu:act-latest platform= username= forcePull=true
*DRYRUN* [CI/test]   🐳  docker create image=catthehacker/ubuntu:act-latest platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
```

Two consequences follow. First, no
working Docker daemon means no real runs
— the planner still works, execution
does not. Second, the container is the
isolation boundary, and it is a boundary
with a door: act mounts the Docker
socket into some action containers and
copies your whole working directory in,
so treat a workflow you did not write as
what it is — code you are choosing to run
with considerable power over your
machine. Read workflows before running
them, the way you would read a script
before piping it to a shell.

## The stand-ins for GitHub's services

A real runner comes with services behind
it: a place `actions/checkout` clones
from, the cache and artifact stores,
a token (`GITHUB_TOKEN`) with permissions
on the repository. act provides local
stand-ins for the pieces a workflow can
touch — its own cache and artifact
servers, run on your machine when a
workflow asks for them, and a locally
minted token. The chapter-10 material on
secrets is part of this picture: values
you pass with `--secret` or a `.secrets`
file are handed to the job as GitHub
would hand them, and act masks them in
its log. Chapter 14 is honest about which
stand-ins are approximations.

## Where things live

- `~/.config/act/actrc` — your user
  configuration; act writes it for you
  the first time it asks the image
  question (chapter 5).
- `.actrc` in the repository — the
  project's configuration, same format
  (chapter 11, including the trust rule
  that limits what a project's file may
  set).
- `~/.cache/act` — downloaded actions and
  the workspaces act builds for jobs.
- `.secrets`, `.env`, `.vars` in the
  repository — the default files act
  reads secret, environment, and variable
  values from (chapter 10).

Check: you can point at each part in the
lab's own transcripts — the planner's
table in t02, the event and inputs in
t09, the image question in t04, the
Docker requests in t05, and the
configuration files in t15 and t16, all
under `act-lab/transcripts/`.
