# Events, Inputs and Secrets

Outcome: you can make a local run stand
for a specific event — a push of a
particular branch by a particular person,
a button press with particular inputs —
and hand jobs the secrets they expect,
without printing those secrets anywhere.

## The event is the run's premise

`act push` and `act workflow_dispatch`
are not two tools; they are two premises.
The event name decides which workflows
fire (chapter 4) and stocks the
**context**: the values expressions like
`${{ github.event_name }}`,
`${{ github.ref }}`, and
`${{ github.actor }}` resolve to inside
steps. Three ways to shape it, in order
of increasing realism:

1. **Bare.** `act push`. act reads your
   git repository for the branch and
   commit, and takes the actor from
   `--actor` (default `nektos/act`).
   Outside a git repository it warns that
   it cannot, and proceeds with less
   context (transcript t13).
2. **Flags.** `--actor octocat`,
   `--defaultbranch`, `--env`,
   `--input` — small facts overridden by
   hand for one run.
3. **A payload file.** `--eventpath
   push-event.json` hands act the JSON
   document GitHub would have delivered
   with the event: the ref, the
   repository's full name, the sender,
   the head commit. The lab's payload is
   `act-lab/project/push-event.json`, and
   transcript t10 dry-runs a push against
   it.

What the lab could verify: the plan is
built for the event you name, with the
payload accepted and the actor set —
every dry run in t09 and t10 was shaped
by its flags. What it could not: the
context values *inside* a running step,
since no step ran on the lab machine.
How fully `${{ github.* }}` matches
GitHub's own values for exotic events is
documented behaviour, and chapter 14
notes the general rule — common events
are faithful, rare ones less so.

## Inputs for manual workflows

A `workflow_dispatch` workflow can
declare **inputs** — the form fields on
GitHub's "Run workflow" page. Locally,
the form is a flag:

```bash
act workflow_dispatch --input name=World
```

The lab's `greet.yml` declares exactly
that input (default `world`), and the
job's first step greets `${{ inputs.name
}}`. Transcript t09 is the dry run of
the command above. Repeated `--input`
flags fill repeated fields, and an
`.input` file in the repository is read
when present.

## Secrets: in by flag or file, never in the log

Workflows expect secrets the way GitHub
provides them: by name, from outside the
repository. act's equivalents:

```bash
act workflow_dispatch --secret DEMO_TOKEN=swordfish
act workflow_dispatch --secret-file .secrets
```

(plus a `.secrets` file in the repository,
which act reads by default). The value
travels into the job's environment as
`${{ secrets.DEMO_TOKEN }}`; it is never
written into the workflow file, and act
masks secret values in its own log
output — `--insecure-secrets` exists to
switch that masking off, and its help
text carries the project's own warning,
"NOT RECOMMENDED".

The lab verified the half of this that a
dry run can show, with an invented token
in a workflow built for the purpose
(`act-lab/extras/secret-repo/`),
transcript t14: the plan for both
secret-using steps builds and "succeeds"
as a plan, and the value `swordfish`
appears nowhere in act's output — the
only place it exists is the command the
lab typed. The masking itself, stars in
a live log where a step echoes its
secret, is documented behaviour the lab
could not exercise, because its steps
could not run (chapter 8).

## Secrets are still secrets

Two plain cautions, because local runs
make secret-handling feel casual:

- A `.secrets` file is a list of live
  credentials sitting in a working
  directory. Keep it out of git (act
  respects `.gitignore` when copying
  files, but *you* are the one who must
  write the ignore rule), and prefer
  values you can revoke.
- A local run gives the workflow —
  including any actions it pulls — the
  secrets you passed, inside a container
  on your machine. That is the point of
  the tool and also the risk: run
  workflows you have read, with the
  secrets they need and no others.

Check: in transcript t14, search act's
entire output for the token's value and
find it absent; in `act-lab/project/
push-event.json`, find the three facts
(`ref`, repository, sender) a bare
`act push` would otherwise have to guess
or take from git.
