# Installing act

Outcome: act is on your machine, its
version prints, and you know whether your
Docker is ready — the two checks every
later chapter assumes.

## What you need first

Docker, installed and running, is the
only hard requirement for real runs: a
Docker Desktop on macOS or Windows, or
the Docker engine on Linux. The planner
commands (list, graph, validate, dry run)
work without it, and this guide's lab
proved that on a machine whose Docker
could pull images but — for reasons
specific to that sandbox — could not
start containers. Check the daemon before
anything else:

```bash
docker info
```

You want a `Server:` section with a
version, not a connection error. The
lab's (transcript t01):

```text
 Server Version: 29.1.3
 Operating System: Ubuntu 24.04.5 LTS (containerized)
 CPUs: 2
 Total Memory: 7.749GiB
```

If instead you see `Cannot connect to the
Docker daemon`, Docker is installed but
not started — start it (open Docker
Desktop, or `sudo systemctl start
docker` on Linux) and check again. Nearly
every "act does nothing" report is this.

## The install the lab verified

The lab downloaded the official release
tarball from the project's GitHub
releases, checked it against the
release's own checksums file, and unpacked
a single binary:

```bash
curl -sL -o act.tar.gz https://github.com/nektos/act/releases/download/v0.2.92/act_Linux_x86_64.tar.gz
sha256sum act.tar.gz
tar xzf act.tar.gz
./act --version
```

The checksum matched the published one
(`c9e13f0e…5441ac7a1`), and the version
printed:

```text
act version 0.2.92
```

Pick the asset for your platform on the
releases page (`act_Linux_x86_64`,
`act_Linux_arm64`, `act_Darwin_arm64`, and
so on), and do compare the checksum —
the file you are installing is a program
you will hand your Docker daemon to.
Move the `act` binary somewhere on your
`PATH` (for example `~/.local/bin`) and
the install is done; act has no config
daemon, no service, nothing else to set
up.

## Other routes (documented, not run here)

The project documents installs through
the usual package managers — Homebrew on
macOS, winget and Chocolatey on Windows,
several Linux package managers, and a
one-line install script on the project's
site that downloads the same release
binary. These are described from the
project's documentation; the lab verified
only the tarball route above. Whichever
route you take, finish with the same
check:

```bash
act --version
```

## The first thing that will surprise you

Do not be alarmed when your first actual
command — even a harmless `act --dryrun`
— stops and asks which size of runner
image you want, and waits. That question
is normal, it happens once, and on a
machine with no terminal attached it
waits forever. It deserves, and gets, its
own chapter: chapter 5. If you are
reading ahead in a script or a CI job of
your own, know now that the fix is to
answer it once interactively, or to pass
`-P` (chapter 9), before automating
anything.

Check: `act --version` prints a version,
`docker info` shows a server section, and
you can say which of the two would block
a real run if it failed. (Docker. The
planner forgives; execution does not.)
