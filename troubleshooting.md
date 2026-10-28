# Troubleshooting

Outcome: the failures this guide's lab
actually met — plus the two every act
user meets — each with its cause and its
fix. Read the error's layer first: plan,
registry, daemon, or container. The
layer is the diagnosis.

## act hangs, saying nothing new

The first-run question (chapter 5) is
waiting for an answer your terminal-less
invocation cannot give. The transcript
of the question sits in the output;
act is not working, it is asking.
**Fix:** run act once interactively and
answer, or pass `-P`, or write an actrc
(chapters 5, 9, 11). The lab lost a dry
run to this (transcript t04); scripts
and agents lose real time to it.

## "Cannot connect to the Docker daemon"

`docker info` will show the same. Docker
is not running — planning commands
forgive this, runs do not (chapter 3).
**Fix:** start Docker (Docker Desktop,
or the engine service) and retry. If
`docker info` succeeds but act still
complains, check `DOCKER_HOST` and the
`--container-daemon-socket` setting
against the daemon you actually run.

## The pull fails with an auth error or EOF

The lab's first real run (transcript
t06): the daemon's sign-in request to
Docker Hub was cut mid-flight by a
network that intercepts connections.
**Fixes, in order:** retry (the same
machine pulled another Docker Hub image
minutes later — episodes pass); pull
the same image from its other registry,
`ghcr.io/catthehacker/ubuntu:act-latest`,
and map to it with `-P` (chapter 9); or
check whether your network needs a proxy
the *daemon* — not your shell — is
configured with.

## "no image found" / platform not mapped

A workflow asked for a platform your
mapping does not cover — often
`ubuntu-24.04`, or a Windows/macOS
platform no mapping can satisfy
(chapter 9). **Fix:** add a `-P` line
for the platform, in the command or an
actrc, unless the platform is Windows or
macOS, in which case the honest answer
is that act cannot run that job.

## The container will not start, with namespace errors

`operation not permitted` around
`netlink` or `setns` when a container
starts (transcripts t07 and t08) means
the *host* forbids containers' low-level
operations — you are likely inside a
restricted sandbox, a container yourself,
or an unprivileged environment. Test
with `docker run --rm hello-world`: if
that fails the same way, no act setting
will save the run on this machine; the
planner half of act is what you have.
On a normal host this error should not
appear at all.

## Validation is green but GitHub rejected the workflow

act's schema is a reading of GitHub's
rules, not the rules (chapter 6). The
verified case: a job missing `runs-on:`
passes every local check. **Fix:** read
GitHub's rejection message — it names
the exact line — and add the case to
your own pre-push habits. `--strict`
narrows the gap; it does not close it.

## Warnings that git information is missing

Outside a git repository act warns it
cannot read a ref or revision (transcript
t13) and builds the event with less
context. Harmless for planning; for runs
that branch on the ref, `git init` the
project (or pass `--defaultbranch` and
an `--eventpath`) so the context is what
you meant it to be.

## A step fails locally but passes on GitHub

Usually the image, not the workflow: a
tool the real runner pre-installs is
absent in the medium or micro image, or
an action assumes the runner's layout
(chapters 9 and 14). **Fix:** check what
the step assumed is installed; install
it in an earlier step, move to the large
image, or build your own runner image —
the mapping makes all three one-line
changes.

## The disk filled up

Images (chapter 5) plus act's cache and
per-run containers add up; the lab's
single medium image was 1.63 GB stored.
**Fix:** `docker images` to see the
tenants, `docker rmi` the mappings you
have abandoned, and `docker system df`
before blaming act for what Docker is
keeping.

## A secret appeared where it should not

If a step prints a secret and it shows
in the log in clear text, check for
`--insecure-secrets` (it exists to do
exactly that, chapter 10) and for the
value leaking through a *file* the step
prints rather than a variable act knows
is secret. Masking covers values act was
told about, in output it renders; a
token hard-coded in a workflow file is
not a secret act can protect — it is a
commit you need to rotate.

Check: every error above names its
layer, and each layer has a test that
does not involve act at all (`docker
info`, a manual `docker pull`, `docker
run hello-world`). Run the layer's test
before re-running act.
