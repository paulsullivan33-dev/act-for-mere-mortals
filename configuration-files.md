# Configuration Files

Outcome: you know every file act reads
before you ask it to — your user actrc,
the project's `.actrc`, and the `.env`,
`.vars`, `.secrets`, and `.input` files —
and the one safety rule that governs the
project's file.

## The idea: flags, written down

Every actrc file is just act's command-
line flags, one per line, written in a
file instead of typed. The line from
chapter 9 —

```text
-P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
```

— does the same work in a file as `-P
ubuntu-latest=…` does on the command
line. Anything `act --help` lists can
live there: image mappings, a default
event, an artifacts path, verbose
logging. (`act --list-options` prints
every settable option as JSON —
transcript t16 is the full, long list —
which is the reference the files are
written against.)

## The two actrc files

- **Yours:** `~/.config/act/actrc`. Read
  on every run, in every repository. act
  itself creates this file the first time
  you answer the image question (chapter
  5) — the lab's copy held exactly the
  four `-P` lines the answer wrote.
- **The project's:** `.actrc`, in the
  repository act is run from. Read after
  yours, so the project can specialise
  what you set globally.

Command-line flags are applied last and
win over both. The lab verified the
project file end to end: with the GHCR
mapping in `act-lab/project/.actrc` and
no `-P` typed, a dry run planned around
the GHCR image (transcript t15).

## The trust rule

A project's `.actrc` arrives with the
repository — which means it was written
by whoever wrote the repository, who is
not always you. So act limits it. The
option's own description, from the
`--list-options` JSON in transcript t16:

> `trust-project-actrc` — "Apply every
> flag in ./.actrc. Without it, ./.actrc
> may only set flags that do not reach
> host resources, and $VAR references in
> it are not expanded."

In other words: a cloned project's file
can set harmless preferences (an image
mapping was accepted in the lab without
any trust flag), but flags that would
touch the host — bind mounts, socket
paths, privileged containers — are
refused unless *you* add
`--trust-project-actrc` on the command
line or in your own user actrc, where a
project file cannot put it. It is a
small, well-placed piece of distrust,
and worth knowing about before you run
act in a repository someone sent you:
the same caution as chapter 2's rule
about workflows themselves, applied to
the config.

## The data files

Beside the actrc files, act reads four
dotfiles from the repository root when
they exist, each named by a matching
`--…-file` option you can override:

- `.env` — environment variables for the
  jobs (`--env-file`),
- `.vars` — repository **variables**, the
  `${{ vars.… }}` context (`--var-file`),
- `.secrets` — secret values, chapter
  10 (`--secret-file`),
- `.input` — dispatch inputs, chapter 10
  (`--input-file`).

All four are plain `NAME=value` lists.
The one that matters most is the one
that must never be committed: `.secrets`
belongs in the repository's `.gitignore`
from the day it is created — chapter 10
says why, and chapter 14 counts a leaked
secrets file as a limit of the workflow,
not of the reader.

Check: the lab's user actrc (four `-P`
lines, chapter 5), the lab's project
`.actrc` (one `-P` line, transcript t15),
and the trust rule's wording (transcript
t16) are all in the repository. If your
own dry run ignores a project mapping,
check you are standing in the repository
that holds the `.actrc` — the file is
looked for where you run, not where the
workflows live.
