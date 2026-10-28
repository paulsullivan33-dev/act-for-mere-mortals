# Limits

Outcome: you can name, without
hesitating, the ways a green local run
can still fail on GitHub — and the ways
act itself can fail you at home.

## It is a stand-in, not the stage

The container image approximates a
GitHub runner; it is not one. Tools
present on the real runners can be
absent in the medium and micro images
(chapter 9), versions drift, and the
large image is a snapshot that ages.
A step can pass locally against an old
tool and fail on GitHub against the new
one — or, sneakier, the reverse. act
narrows the gap between desk and cloud;
it does not close it.

## Validation is shallower than GitHub's

Verified in chapter 6: a job with no
`runs-on:` passes `act --validate`,
`act --validate --strict`, and even a
dry run (which notes the omission and
exits 0 anyway). GitHub refuses the
file. There will be other such gaps —
act's own schema is a reading of
GitHub's rules, not the rules
themselves. Treat act's green light as
"readable and plausible", and a first
push as the authority.

## Platforms act cannot be

Only Linux containers exist in this
world. Workflows for `windows-latest`
and `macos-latest` have no faithful
local form (chapter 9), and a workflow
whose jobs span all three systems can
only ever be partly rehearsed at home.
The same goes for GitHub's larger and
specialised runners, and for anything
that depends on the runner's exact
network neighbourhood.

## Services are approximations

The cache and artifact services act runs
on your machine imitate the interfaces
actions expect; they are not GitHub's
distributed stores, and behaviour around
size limits, retention, and cross-run
sharing differs. The `GITHUB_TOKEN` in a
local run is locally minted: steps that
test permissions, call the API as the
token, or push back to the repository
are rehearsing with a prop. Anything a
workflow does *to GitHub itself* —
releases, comments, deployments — can
at best be dry-run at home.

## Not every action travels

JavaScript and Docker actions are the
portable kinds. Composite actions
usually work; actions that assume the
real runner's filesystem layout, call
hosted services, or are themselves
wrappers around a cloud do not always.
When an action fails locally and passes
on GitHub, the action's assumptions —
not your workflow — are the first
suspect.

## The local costs are real

Images are downloads (chapter 5's menu:
500 MB to 17 GB) and disk once stored —
the lab's one medium image occupied
1.63 GB, on a machine sharing 7.5 GB
with the rest of its system. Every run
re-pulls by default (chapter 9). RAM and
CPU are your own: a matrix that fans out
to twelve jobs is twelve containers'
worth of your laptop. And a workflow is
code with your Docker daemon's power
(chapter 2) — act will run a malicious
or merely careless workflow exactly as
faithfully as a kind one.

## Secrets, close to the disk

`.secrets` files, tokens in shell
history, secret values in a kept
container: the local workflow creates
copies of credentials in places GitHub's
design keeps them out of (chapters 10
and 11). The masking is real but it is
not a vault.

## This guide's own limit, repeated

The lab that verified this guide could
pull images but could not start
containers (chapter 8, transcript t08),
so step execution, the artifact and
cache servers in action, and live secret
masking are documented here, not
demonstrated. The planner, the images,
the configuration, the failure layers,
and the validator's blind spot are
demonstrated, with transcripts. A guide
that ran act on an ordinary machine
could show more of the run itself; this
one shows the machine it had, and says
exactly where the evidence stops.

Check: you can give one example each of
a workflow that passes locally and fails
on GitHub (missing-`runs-on` class,
image tool drift), and of a workflow
act cannot rehearse at all (a
`windows-latest` job).
