# Repository Guidelines

## Chorus

Chorus is a Gall agent that lets agent-driven Urbit ships share resources with each other.

A ship publishes listings — a bio, announcements, desks it serves, MCP tools/prompts/resources/resource-templates, agent skills (per agentskills.io), and slips of shared notes — and other ships poll it for them. A listing is small: it names a thing and, where the thing has a body, carries the body's digest. A poll never brings a body.

The agent in `desk/app/chorus.hoon` keeps one piece of state: the `(set ship)` it polls. Everything it publishes and hears lives in the content store, in four Kademlia agent wrappers stacked around the agent: `content-store-agent`, `content-discovery-agent`, `content-routing-agent` and `kademlia-agent`, imported from `gwbtc/kademlia`.

Chorus reserves the topics in `+topics` of `desk/lib/chorus.hoon`, all under `/chorus`. Under each, a ship publishes one value, a `shelf` (see `desk/sur/chorus.hoon`), named by the topic in the `%chorus` namespace of the content store. Chorus checks a shelf's type and rules with `+vet-shelf` before it publishes one and when it hears one. A new topic needs a new `shelf` case and no state transition.

Clients (e.g. an MCP server driving the ship) poke `%chorus-list`, `%chorus-publish`, `%chorus-retract`, `%chorus-seek` and `%chorus-fetch`, and receive `%chorus-update` facts.

### Reading the content store

The agent reads the wrappers' state by scrying itself under `/~/content-store`. A scry sees the state as the last event left it. The content store settles our own name when it accepts a `%put`, so the next publish reads the last one.

A private listing grows in the agent's `%grow` namespace at a path that mirrors its topic. `+grown` in `+hc` reads it back with a local scry of the farm (`%gt` to list, `%gx` to read), and `+ours` stocks it over `+public`, the shelf the content store holds. Publish and renew from `+public` alone, or a private listing leaks. A retraction grows an empty shelf over the path; a tombstone would block the `%gx`.

Chorus vets another ship's shelf once, when a `%get` result brings it in. The content store keeps the cask and settles the name before chorus sees either, so chorus sends `%unname` and `%evict` for a cask that fails, and the store applies both inside the same event. A name the store holds therefore passed, and `+held` only types a shelf, with `+type-shelf`. A result whose digest matches the name's last digest skips the vet.

### Slips

The agent stamps a slip with its author, its time and its FQSP, the remote scry path of that revision: `/~zod/g/x/3/chorus//1/chorus/cabinet/notes/foo`. Every slip grows its page at `/chorus/cabinet/<path>`, public or private, so the FQSP resolves with `%keen`, on our own ship too (gwbtc/urbit#84). The page is a `%chorus-cabinet` cask holding the one slip. Slips link to each other by FQSP.

The cabinet shelf is an `index`: a `stub` for each slip, which is the slip less its text, plus `hax`, the digest of its page. The shelf travels under the `%chorus-index` mark, and a ship that polls us learns each slip's path and author from it.

A slip's text comes on request. `%chorus-fetch` names a drawer and a set of ships; for each stub under it whose page we lack, `+get-page` asks the content store for a `%direct` get of `hax` from the FQSP. The store checks the page against the digest and keeps it, so the store is a cache of FQSP answers that never go stale. Chorus vets the page once, with `+vet-page`, when the result arrives at `/page`: the markdown parse costs about 1.7 seconds a slip, so each page takes its own event. A page that fails is evicted, so a page the store holds passed.

`+whole` joins a stub to its page: ours from our own farm, another ship's from the store. `/x/cabinet/paths` lists every stub and whether we hold its page; `/x/cabinet/drawer` and `/x/cabinet/slip` give only slips we hold whole.

A ship that published before slips left the shelf holds a cabinet of whole slips under the `%chorus-cabinet` mark. `+relist`, on load, publishes it again as an index. A new ship refuses an old ship's cabinet by its mark, and an old ship a new one's.

### Content hashes

A listing that points at content carries its `digest`: the SHA-256 of the jammed cask, as `+digest-cask` in `lib/content-routing.hoon` computes it. The publisher serves the cask by that digest. Chorus has no wicks and no `wire://` URIs.

## Project Structure & Module Organization

This repository builds the `chorus` Urbit desk. Source Hoon lives under `desk/`: the Gall agent is `desk/app/chorus.hoon`, shared structures are in `desk/sur/`, libraries are in `desk/lib/`, marks are in `desk/mar/`, and MCP-facing files are under `desk/fil/mcp/`. `build.zig` assembles the source desk with pinned upstream dependencies.

The Claude Code adapter lives in another repo: the `chorus` mod in `gwbtc/claude-mods` (`~/gw/claude-mods`) syncs cabinet drawers into Claude Code project memory and draws the `/cabinet` pane. It reads the agent's `/x/cabinet` and `/x/nym` scries over HTTP, so a change to their JSON is a change to the mod. To sync another ship's slips it must first poke `%chorus-fetch`, which `mar/chorus/fetch.hoon` takes as JSON.

Treat `zig-out/` and `.zig-cache/` as generated build output. Edit `desk/` or `build.zig` instead of editing generated files.

## Build, Test, and Development Commands

When you want to check your changed compile, run `zig build -Ddesk=...` where `...` is the `$DEPLOY_DESK` variable in `.claude/settings.local.json`.

After running `zig build -Ddesk=...`, use your `mcp/commit-desk` tool to compile your changes on the target desk on whichever Urbit ship you have configured as an MCP server.

- `zig build` builds `zig-out/` from `desk/` and the pinned dependency imports.
- `zig build build` is the named form of the default build step.
- `zig build clean` removes `zig-out/`.
- `zig build clear` removes `zig-out/` and the cached dependency imports under `.zig-cache/desk-deps`.
- `zig test build.zig` runs the Zig tests for build-helper behavior.
- `zig fmt --check build.zig` checks build-script formatting.

## Coding Style & Naming Conventions

Follow nearby Hoon formatting: two-space indentation, aligned rune bodies, lowercase kebab-case filenames, and short comments that explain intent rather than syntax. Keep shared data shapes in `desk/sur/`, helper code in `desk/lib/`, and agent behavior in `desk/app/chorus.hoon` unless the surrounding code clearly establishes a narrower location.

Gall agents must keep the standard ten-agent-arm shape, such as `+on-poke`; put extra helper arms in a helper core called from those standard arms, as `+hc` is in `desk/app/chorus.hoon`. Do not mix wide-form and tall-form Hoon in the same expression.

For Zig, use standard `zig fmt` formatting and lower camel case for functions and variables. Keep dependency pins and path lists in `build.zig` explicit and easy to audit.

## Testing Guidelines

Running `zig build` verifies that the desk can be assembled, but it does not prove the Hoon compiles on a ship. For Hoon behavior changes, copy the built desk to an Urbit ship and commit it there. Use `zig test build.zig` for changes to the build helper logic.
