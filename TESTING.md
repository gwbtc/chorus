# Aqua integration tests

The Chorus integration tests run against virtual ships managed by `%aqua`.
They require the Groundwire Arvo variants and standard Aqua helper threads in
the host `%chorus` desk.

## Build the test desk

By default, the test build reads Groundwire dependencies from a sibling
`../gw-urbit` checkout:

```console
zig build -Dtests
```

Use `-Dgroundwire` when the checkout is elsewhere:

```console
zig build -Dtests -Dgroundwire=/path/to/gw-urbit
```

A production build omits these external test dependencies:

```console
zig build
```

To install the test build, first create and mount `%chorus` from the Dojo:

```hoon
|new-desk %chorus
|mount %chorus
```

Then replace the mounted desk with the build output. For example, for a pier
at `/path/to/pier`:

```console
zig build -Dtests -Dgroundwire=/path/to/gw-urbit -Ddesk=/path/to/pier/chorus
```

Commit the mounted files from the Dojo:

```hoon
|commit %chorus
```

## Match the kernel

Aqua loads the Ames vane into each guest from the host thread's desk, and
compiles it against the host ship's kernel. The aqua files in the test build
must therefore match the kernel the host ship runs. When they do not, guests
boot and answer scries, and `|hi` between them never completes.

Three files carry the difference: `sys/vane/ames.hoon`, `ted/aqua/ames.hoon`
and `lib/aqua-azimuth.hoon`. Point `-Dgroundwire` at a checkout of the commit
the ship's kernel was built from. To check, compare the three files in the
built desk with those in a `|merge` of the ship's committed `%base`, such as
the `%aqua-base` desk below. Do not compare with a mounted `base/` folder; a
mount can be stale.

## Build the Aqua pill

Start `%aqua`. Make a base desk for the pill: a copy of `%base` with a minimal
bill, so that no guest runs background agents whose timers and traffic swamp
the test:

```hoon
|start %aqua
|merge %aqua-base our %base
|mount %aqua-base
```

The build writes that bill. `-Daqua-base` takes the mounted desk and copies
`desk.bill` into it from the pinned `gwbtc/kademlia` import:

```console
zig build -Dtests -Dgroundwire=/path/to/gw-urbit -Ddesk=/path/to/pier/chorus -Daqua-base=/path/to/pier/aqua-base
```

Commit both desks and give `%aqua` a pill:

```hoon
|commit %aqua-base
|commit %chorus
:aqua &pill +pill/brass %aqua-base %chorus, =prime .y, =cache .y
```

Rebuild the pill whenever code included in the virtual ships changes.

The runner boots a fresh fleet for each test: two fake galaxies, `~bud` and
`~wes`. Fake ships suit these tests, which need delivery and test no PKI
decision. Nothing in them covers Groundwire keys or nyms.

A poll asks a ship for nine topics through one poke gate per peer. Between
aqua ships that takes about thirty seconds, so each test polls no more than
it must.

A test does not wait out the ten-minute poll. Chorus polls a ship when it is
added to the set, so a test adds the publisher again to poll it again.

A test waits for a publish to settle before it polls. A ship that holds a
replica of the publisher's last pointer answers a poll from it, so a poll
that races a publish hears the old value. The harness watches the
publisher's `/published` path for the `%chorus-published` fact.

## Run tests

Run the complete suite:

```hoon
-chorus!ph-test ~ ~
```

Run a directory or a matching test-arm prefix:

```hoon
-chorus!ph-test [~ /ted/ph/message] ~
-chorus!ph-test [~ /ted/ph/message/ph-test-message-slip] ~
```

Run one test arm:

```hoon
-chorus!ph-test [~ /ted/ph/message/ph-test-message-unlisted] ~
```
