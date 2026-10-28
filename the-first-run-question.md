# The First-Run Question

Outcome: you know why act stops and asks
about image sizes before its first run —
including before a dry run that downloads
nothing — how to answer it, what it
remembers, and how to keep it from ever
hanging a script.

## What happens

The first time act prepares to run
anything and finds no default image
configured, it asks, in your terminal:

```text
? Please choose the default image you want to use with act:
  - Large size image: ca. 17GB download + 53.1GB storage, you will need 75GB of free disk space, snapshots of GitHub Hosted Runners without snap and pulled docker images
  - Medium size image: ~500MB, includes only necessary tools to bootstrap actions and aims to be compatible with most actions
  - Micro size image: <200MB, contains only NodeJS required to bootstrap actions, doesn't work with all actions
```

(Transcript t04, terminal codes removed.)
You move with the arrow keys and press
Enter. **Medium** is highlighted by
default, and Medium is the right answer
for nearly everyone: it carries the tools
most actions need to start, at a fiftieth
of the large image's disk cost. The large
image exists for workflows that lean on
GitHub's runners having a particular tool
pre-installed; the micro image is for
workflows whose steps are all Node.js
actions.

## What it remembers

Your answer is written, as four lines of
configuration, to `~/.config/act/
actrc`. The lab's file, written by act
itself when the question was answered:

```text
-P ubuntu-latest=catthehacker/ubuntu:act-latest
-P ubuntu-22.04=catthehacker/ubuntu:act-22.04
-P ubuntu-20.04=catthehacker/ubuntu:act-20.04
-P ubuntu-18.04=catthehacker/ubuntu:act-18.04
```

Each line maps a platform name — the
words a workflow puts after `runs-on:` —
to the container image that will stand in
for it. That is all the question was
really asking: *which images shall I
fetch when a workflow says
`ubuntu-latest`?* Chapter 9 is about
changing those mappings on purpose.
Chapter 11 covers the file itself.

## The trap, which the lab fell into

The question appears **before act does
anything else**, including before a
`--dryrun` that would never pull an
image. And if there is no terminal —
act started from a script, an editor task,
a cron job, an automated agent — the
question still appears, printed to the
output, and act waits for an answer that
cannot come. The lab's first dry run sat
exactly like that, silent and patient,
until it was put out of its misery
(transcript t04 is that run). The output
file showed the question; nothing about
the behaviour said "waiting for input"
except the absence of progress.

The escapes, any one of which is enough:

- Run act once by hand in a terminal and
  answer; the `actrc` remembers.
- Pass an image mapping on the command
  line: `act -P ubuntu-latest=
  catthehacker/ubuntu:act-latest …` —
  chapter 9.
- Write the `actrc` yourself, in your
  user config or in the project's
  `.actrc` — chapter 11.

If you automate act, do one of these
first, and consider the general lesson
free of charge: a tool that goes quiet
with a question in its output is waiting,
not working.

## What the question tells you about act

Notice what the three sizes admit: there
is no exact copy of a GitHub runner on
offer. The large image is a snapshot *of*
the runners, the medium an approximation,
the micro a bootstrap. act's whole design
is in that menu — your workflow file is
real, the machine it runs on is a
stand-in, and you choose how close a
stand-in you can afford. Chapter 14
collects what follows from that.

Check: after answering once, a second
`act --dryrun push` goes straight to the
plan with no question (transcript t05 ran
in the same sitting as the answer). And
`cat ~/.config/act/actrc` shows the four
`-P` lines your answer wrote.
