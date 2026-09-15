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

## Build the Aqua pill and snapshots

Start `%aqua` and give it a pill containing `%base` and `%chorus`:

```hoon
|start %aqua
:aqua &pill +pill/solid %base %chorus
```

Rebuild the fleet snapshots whenever code included in the virtual ships
changes:

```hoon
-chorus!ph-fleet
```

This creates `%chorus-message`, a two-ship snapshot for message tests, and
`%chorus-gossip`, a four-ship Groundwire topology for gossip and crowd tests.

## Run tests

Run the complete suite:

```hoon
-chorus!ph-test ~ ~
```

Run a directory or a matching test-arm prefix:

```hoon
-chorus!ph-test [~ /ted/ph/message] ~
-chorus!ph-test [~ /ted/ph/gossip/ph-test-tell] ~
```

Run one test arm:

```hoon
-chorus!ph-test [~ /ted/ph/crowd/ph-test-crowd-kids] ~
```
