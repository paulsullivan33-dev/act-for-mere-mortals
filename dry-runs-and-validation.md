# Dry Runs and Validation

Outcome: you can ask act "what *would*
you do?" for any event, read the answer,
and validate a workflow file before
pushing it — and you know exactly how
much that validation is worth, because
this chapter shows it missing something
real.

## The dry run

Add `-n` (or `--dryrun`) to any run
command and act builds the full plan —
event, jobs, stages, images, containers,
steps — and then performs none of it.
Every line is prefixed `*DRYRUN*`, and
the Docker lines are the literal requests
a real run would make. From transcript
t05, the `test` job of the lab's CI
workflow:

```text
*DRYRUN* [CI/test] ⭐ Run Set up job
*DRYRUN* [CI/test] 🚀  Start image=catthehacker/ubuntu:act-latest
*DRYRUN* [CI/test]   🐳  docker pull image=catthehacker/ubuntu:act-latest platform= username= forcePull=true
*DRYRUN* [CI/test]   🐳  docker create image=catthehacker/ubuntu:act-latest platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
*DRYRUN* [CI/test]   🐳  docker run image=catthehacker/ubuntu:act-latest platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
*DRYRUN* [CI/test]   ✅  Success - Set up job
*DRYRUN* [CI/test] ⭐ Run Main actions/checkout@v4
*DRYRUN* [CI/test]   ✅  Success - Main actions/checkout@v4 [9.643004ms]
*DRYRUN* [CI/test] ⭐ Run Main Run the tests
*DRYRUN* [CI/test]   ✅  Success - Main Run the tests [30.538447ms]
*DRYRUN* [CI/test] ⭐ Run Complete job
*DRYRUN* [CI/test]   ✅  Success - Complete job
*DRYRUN* [CI/test] 🏁  Job succeeded
```

Read those ✅ marks correctly: in a dry
run a step "succeeds" by being *planned*,
not by being run — `Run the tests` took
30 milliseconds because no test ran. What
the dry run genuinely proves:

- act can parse every workflow the event
  touches;
- the jobs, their order, and their steps
  are the ones you think they are;
- each job's image mapping resolves to a
  named image, and these are the exact
  Docker operations a real run starts
  with.

That is a real and useful amount of
truth. It is the shape of the run, checked
— not the run, passed.

Any event can be dry-run: `act --dryrun
workflow_dispatch --input name=World`
plans the manual workflow just as fully
(transcript t09), and `--eventpath` and
`--actor` shape the event the plan is
built for (chapter 10, transcript t10).

## Validation

```bash
act --validate
act --validate --strict
```

On the lab's healthy project both print
nothing but the Docker-host note and exit
0 (transcript t10): the files parse, the
structure act checks is sound. Silence
plus exit code 0 is the whole report.

## What validation catches

A workflow whose YAML is malformed —
indentation off by a space in the wrong
place — fails everything, list included,
with the parser's complaint and exit code
1. The lab's broken file (in
`act-lab/extras/broken-yaml/`), transcript
t11:

```text
Error: workflow is not valid. 'broken.yml': yaml: line 8: did not find expected '-' indicator
```

That is the most common real-world
workflow failure — a file GitHub would
reject unread — caught locally in a
second. If act did nothing else, this
alone would justify it in a workflow
author's toolkit.

## What validation misses — verified

Now the counterweight, also from the lab.
The file in `act-lab/extras/
broken-schema/` is valid YAML describing
a job **with no `runs-on:`** — no
platform, nowhere for the job to run.
GitHub requires `runs-on` on every job
that is not calling a reusable workflow,
and refuses such a file. act's verdicts,
transcript t12:

- `act --list` — lists the job, exit 0.
- `act --validate` — silent, exit 0.
- `act --validate --strict` — silent,
  exit 0. The strict schema check does
  not flag it either.

Only at dry-run time does act remark on
it at all, transcript t13, and even then
as a passing note on a run that still
exits 0:

```text
*DRYRUN* [Wrong shape/test] 'runs-on' key not defined in Wrong shape/test
```

The same transcript shows a second,
milder lesson: that folder was not a git
repository, so act warned it could not
read a ref or revision from git, and
planned on regardless. act is forgiving.
GitHub is less so.

So the rule for this chapter, stated
plainly: **validation proves a workflow
is readable, not that GitHub will accept
it.** Use it to catch the syntax errors
and the shape of the plan, and let a
first real push to a branch — where a
failure is cheap — be the check of last
resort for the semantics act does not
enforce.

Check: `--validate` exits 0 on the lab
project and 1 on the broken-YAML extra;
the dry run of the schema-broken extra
contains the `'runs-on' key not defined`
line — and still exits 0, which is the
whole point.
