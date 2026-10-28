# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's traffic is the lab talking to itself.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 14 names what the tool
   cannot do: the stand-in images' drift from real runners,
   validation that is shallower than GitHub's (demonstrated),
   platforms no container can be, approximated services, and
   this lab's own ceiling.
8. **The caution is in the text, early.** Chapter 2 states the
   rule plainly — a workflow is code, and act runs it with your
   Docker daemon's powers, so read workflows before running
   them — before any procedure depends on it, and chapters 10
   and 11 return to it for secrets and project config files.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu 24.04 sandbox.
act **0.2.92** was installed from the project's official
release tarball (SHA-256 checked against the release's
checksums file) and exercised against a tiny invented project
(`act-lab/project/`) with two workflows. The Docker daemon
(29.1.3) could pull images but — being itself inside a
restricted sandbox — could not start any container, which act
inherited: this guide's lab therefore verifies act's planner,
images, configuration, and failure behaviour for real, and
teaches step execution from the verified dry-run plan and the
project's documentation, labelled as such wherever it appears.
All transcripts live in `act-lab/transcripts/` (terminal
escape sequences stripped from t03–t05; no content altered).

Run for real, with transcripts as evidence:

- Install and version; the Docker daemon's server version,
  CPUs, and memory read back (t01).
- `act --list` over two workflows and three jobs, with
  stages from `needs:`; `--list --job` filtering; `--graph`
  (t02, t03).
- The first-run image question: it appears before a dry run,
  it hangs with no terminal (the run was left waiting, then
  stopped), and answering Medium writes four `-P` lines to
  `~/.config/act/actrc` (t04, and the actrc itself, chapter 5).
- `act --dryrun push`: the complete plan for both jobs,
  including the literal docker pull/create/run requests and
  the checkout step (t05).
- `act --dryrun workflow_dispatch --input name=World` (t09),
  and `act --dryrun push --eventpath push-event.json
  --actor octocat` (t10).
- `act --validate` and `act --validate --strict` passing
  silently, exit 0, on the healthy project (t10).
- Malformed YAML failing list and validate with the parser's
  error and exit 1 (t11).
- A job with no `runs-on:` passing list, validate, and
  strict validate at exit 0; the dry run noting
  `'runs-on' key not defined` and still exiting 0; git
  warnings when run outside a repository (t12, t13).
- Secrets in a dry run: the invented token value appears
  nowhere in act's output (t14).
- A project `.actrc` image mapping honoured with no `-P`
  flag given (t15); `act --list-options` and the
  trust-project-actrc rule's own wording (t16).
- Image pulls: `ghcr.io/catthehacker/ubuntu:act-latest`
  downloaded in full; `node:16-buster-slim` downloaded from
  Docker Hub; the act image's stored size, 1.63 GB (chapter 9).
- Two real runs (t06, t07): the first failing when Docker
  Hub's sign-in endpoint was cut mid-handshake (EOF), the
  second — on the GHCR image — passing pull and create and
  failing at container start with a namespace
  `operation not permitted`, proven environmental by
  `docker run --rm hello-world` failing the same way with
  no act involved (t08).

Documented only — described from the project's documentation,
not run, and the text does not claim otherwise:

- Steps executing inside a container, the working directory
  being copied in for checkout, `--no-skip-checkout`,
  `--reuse` and inspecting a kept container, and the JSON
  log format (chapter 8 and the recipes that use them).
- The artifact and cache servers in operation, the locally
  minted token, and live masking of a secret a step echoes.
- Context values (`${{ github.* }}`, `${{ inputs.* }}`)
  resolving inside running steps, and matrix fan-out.
- Non-Linux platforms, GitHub Enterprise instances, watch
  mode, and the neighbours in chapter 13, which are
  characterised, not benchmarked.

Fixtures are this guide's own and deliberately generic: a
twenty-line shell script that counts words, its test, a
greeting workflow, an invented event payload for a project
that does not exist, and one made-up secret (`swordfish`)
used to show that act's output does not contain it. No
example is modelled on any real person, network, service or
organisation.
