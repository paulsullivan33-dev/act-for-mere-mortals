# The Neighbours

Outcome: you can say what each neighbour
does that act does not, and vice versa.
The comparisons in this chapter are
characterisations from each tool's
documentation, not benchmarks — the lab
ran act only.

## GitHub's own runners

The original, and still the ground truth.
Pushing to GitHub gets you the real
images, the real services (cache,
artifacts, the token with its
permissions), and the exact acceptance
rules for workflow files — including the
ones act's validator misses (chapter 6).
What it costs is the loop: minutes per
run, a commit per attempt, a public log
of your false starts. act exists to move
the *drafting* of a workflow to your
desk; the first push to a real branch
remains the final exam, and chapter 6
says so.

## Pushing to a scratch branch

The poor person's act, and not a bad
one: a throwaway branch, a workflow
limited to it, and GitHub's runners do
the testing. No local tooling, no Docker,
perfect fidelity — and every iteration
is a push, a wait, and another entry in
the run history. Many teams live here
contentedly. act's advantage is only,
but really, the loop time and the
privacy of failing at home.

## gitlab-ci-local

The same idea wearing GitLab's colours:
runs `.gitlab-ci.yml` pipelines locally,
in Docker or a shell executor, before a
push. If your repositories live on
GitLab it is the obvious counterpart,
and the concepts — plan first, container
as runner, local secrets by file —
transfer from this guide almost word for
word. It reads no GitHub workflow files,
and act reads no GitLab ones; the two
tools are mirror images across a format
border.

## Make, just, and Task

Local task runners: `make test`,
`just build`, `task lint`. They run
*commands*, directly on your machine, the
moment you ask — no events, no stages
beyond the dependencies you declare, no
container unless you bring your own.
They answer a different question from
act. If your workflow's steps are really
"the project's own commands", those
commands probably deserve a Makefile
(there is a guide to Make in this
series), and the workflow should call
them — then act, GitHub, and your own
fingers all run the same thing. act is
for the part that is specific to the
workflow file itself: triggers,
conditions, matrices, the shape of the
run.

## Docker Compose

Compose runs *your* services, in
containers you describe, and keeps them
running. act runs *GitHub's* jobs, in
containers it describes, once through.
They share a daemon and little else —
but a workflow step that needs a
database often ends up describing it in
Compose terms either way, and GitHub's
own `services:` feature (which act
imitates) is the same thought inside a
workflow.

## Shell scripts and honesty

The final neighbour is a plain script
that runs the tests on your machine, no
containers, no YAML. For a one-person
project whose CI is two commands, it may
be all you need, and this guide's lab
project secretly agrees: its CI workflow
exists to call `test.sh`, which works
perfectly well alone. Reach for the
workflow file — and for act — when the
workflow itself becomes the thing under
development: triggers, jobs that need
each other, inputs, secrets, the works.

Check: for each tool above you can finish
the sentence "I would reach for it
instead of act when…". If you cannot,
the gap is probably the fidelity-versus-
loop-speed trade, which is the axis this
whole chapter turns on.
