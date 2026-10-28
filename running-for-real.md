# Running for Real

Outcome: you can start a real run, read
its log as it goes, and interpret its
failures — including the two the lab's
own runs produced before a single step
could execute.

## Starting a run

```bash
act push
```

That is the whole command: the event
name, in the repository. Narrow it when
you mean less: `act push --job test` runs
one job; `act pull_request` runs the
workflows that event triggers; plain
`act` with no event defaults to `push`
(or to the single event a lone workflow
listens for). act plans as chapter 6
showed, then hands the plan to Docker:
pull the image, create a container, put
your files in, run the steps, report,
clean up.

## The log as it goes

Each job's lines are prefixed with its
workflow and job — `[CI/test]` — so
parallel jobs stay tellable apart.
Reading down a run, the rhythm is:

- `⭐ Run …` — a step starts (act inserts
  its own housekeeping steps, `Set up
  job` and `Complete job`, around yours);
- `🚀 Start image=…` and `🐳 docker …` —
  the container being fetched and made;
- `| …` — your step's own output, in
  real runs (documented; see below);
- `✅ Success` / `❌ Failure` — the step's
  verdict;
- `🏁 Job succeeded` / `🏁 Job failed` —
  the job's, and act's exit code follows
  the jobs: 0 if all passed, 1 if any
  failed.

## The lab's two real runs

The lab started two real runs. Both are
kept whole in the transcripts, and both
failed before any step of the workflow
could execute — at two different layers,
for two different reasons, which is why
they are worth a chapter instead of a
footnote.

**Run one (transcript t06)** used the
default mapping, and died fetching the
image:

```text
[CI/test]   🐳  docker pull image=catthehacker/ubuntu:act-latest platform= username= forcePull=true
[CI/test] Error response from daemon: Head "https://registry-1.docker.io/v2/catthehacker/ubuntu/manifests/act-latest": Get "https://auth.docker.io/token?scope=repository%3Acatthehacker%2Fubuntu%3Apull&service=registry.docker.io": EOF
[CI/test]   ❌  Failure - Set up job
[CI/test] 🏁  Job failed
```

The daemon reached for Docker Hub and the
connection to its sign-in service was cut
mid-handshake — this sandbox's network
intercepts connections, and that endpoint
did not survive it. Verdict so far: a
*registry* failure, before act's plan was
even tested. The same image exists on
GitHub's registry, and `docker pull
ghcr.io/catthehacker/ubuntu:act-latest`
succeeded on the same machine minutes
later (as did a Node image from Docker
Hub itself — the cut was an episode, not
a wall). Registries have mirrors and
moods; chapter 15 returns to this.

**Run two (transcript t07)** mapped
`ubuntu-latest` to the already-downloaded
GHCR image. Pull and create now pass, and
the run dies one layer deeper:

```text
[CI/test] failed to start container: Error response from daemon: failed to create default sandbox: failed to create a netlink handle: failed to set into network namespace 23 while creating netlink socket: operation not permitted
[CI/test]   ❌  Failure - Set up job
[CI/test] 🏁  Job failed
```

The lab machine is itself a sandbox, and
it refuses the low-level namespace
operations a container's start requires.
The proof that this is the machine and
not act is transcript t08: plain Docker,
no act involved, cannot start the
smallest container there is —

```text
$ docker run --rm hello-world
docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error spawning mount remapping thread: mount source thread: join container mntns: setns: operation not permitted
```

## What happens past that point

On a machine where containers can start —
an ordinary laptop or desktop with Docker
— the run the lab planned continues as
the dry run laid out, and this part is
described from the project's
documentation, not from a lab transcript,
because the lab's machine would not let
it happen:

- The checkout step does not clone from
  GitHub; act copies your working
  directory — including uncommitted
  changes — into the container. That is
  usually what you want locally, and it
  means a local run tests the code *on
  your disk*, which may differ from the
  commit you are about to push.
  (`--no-skip-checkout` makes act run
  the real checkout action instead.)
- `run:` steps execute with the job's
  shell inside the container, their
  output streamed into act's log between
  the ⭐ and ✅ lines.
- A step that exits non-zero fails, the
  job's later steps are skipped unless
  their conditions say otherwise, and
  act moves to the jobs that do not
  depend on the failed one.
- `--reuse` keeps the job containers
  after the run, so you can
  `docker exec` into the scene and look
  around; without it, containers are
  removed as jobs complete.

Check: on the lab transcripts, you can
point at the exact line where each run
stopped and name the layer that stopped
it — registry, then container start. On
your own machine, a successful `act push`
on the lab project ends with `🏁 Job
succeeded` for both `test` and `package`,
and act's exit code is 0.
