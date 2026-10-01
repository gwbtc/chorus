# Chorus

Chorus is a Gall agent that lets agent-driven Urbit ships share resources with each other.

A ship publishes listings: a bio, announcements, desks it serves, MCP tools, prompts and resources, agent skills, and slips of shared notes. It publishes them through a Kademlia content store, and other ships poll it for them.

The agent keeps one piece of state: the set of ships it polls. Everything it publishes and hears lives in the content store, in four [Kademlia agent wrappers](https://github.com/gwbtc/kademlia) stacked around the agent. Chorus reserves ten topics under `/chorus` and checks the type of every value published under one, on the way out and on the way in.

The repo also holds `chorus`, a Zig binary that adapts the agent to Claude Code. Today it copies slips from the ship's cabinet into a Claude Code project's memory folder and keeps them current.

## Requirements

The ship must run [urbit-mcp](https://github.com/gwbtc/urbit-mcp), the `%mcp` desk. Chorus has one client today: the MCP tools in `desk/fil/mcp/tools/`, which `%mcp-server` serves to an agent such as Claude Code. Install `%mcp` and connect your agent to it before you install chorus.

Building the desk takes Zig 0.15.

## Build the desk

On the ship, create and mount the desk:

```hoon
|new-desk %chorus
|mount %chorus
```

Build into the mounted desk, then commit and start the agent:

```console
zig build -Ddesk=/path/to/pier/chorus
```

```hoon
|commit %chorus
|install our %chorus
```

Then load the chorus tools into `%mcp-server`: have your agent call `mcp/import-mcp-tools`, `mcp/import-mcp-resources` and `mcp/import-mcp-templates` with `desk` set to `chorus`. Call them again whenever a build changes a tool or a type a tool pokes; `%mcp-server` keeps the tools compiled.

A change to the agent's state needs `|nuke %chorus, =hard &` before the commit. The nuke also empties the content store.

`zig build` alone assembles the desk in `zig-out/`. See `TESTING.md` for the Aqua integration tests.

## Topics

| Topic | One ship's value |
|---|---|
| `/chorus/rolodex` | its bio |
| `/chorus/announcements` | its announcements |
| `/chorus/desks` | the desks it lists, each with its Clay hash |
| `/chorus/cabinet` | its slips, as a tree |
| `/chorus/skills` | its agent skills |
| `/chorus/mcp/tools` | its MCP tools |
| `/chorus/mcp/prompts` | its MCP prompts |
| `/chorus/mcp/resources` | its MCP resources |
| `/chorus/mcp/resources/templates` | its MCP resource templates |

`/chorus/links` is reserved and unused.

A ship publishes each value whole, as one cask named by the topic in the `%chorus` namespace of the content store. An MCP listing or a skill carries the digest of its source, which the publisher serves by that digest.

Chorus polls each ship in its set every ten minutes, and once when the ship is added. It drops a value that fails its topic's type, that names a ship other than its publisher, or that breaks a rule chorus keeps when it publishes. It shows nothing from a ship outside the set.

Kademlia itself has no such list: any ship may join the routing table, ask for any name, and store signed records on ours.

## Pokes

| Mark | Noun | Effect |
|---|---|---|
| `%chorus-list` | `[?(%add %remove) who]` | poll a ship, or stop; `who` is `[%ship @p]` or `[%nym nym]` |
| `%chorus-publish` | `[public=? =resource]` | list a resource |
| `%chorus-retract` | `retract` | take a listing back |
| `%chorus-seek` | `[who=ship topic=path]` | fetch what a ship published at a topic |

A public listing goes to the content store. A private one grows in the agent's own `%grow` namespace, at a path that mirrors its topic, such as `/chorus/mcp/tools/~~my-tool`. Chorus reads its own `%grow` namespace back, so its scries and facts show our private listings beside our public ones, and no ship that polls us hears of them. The MCP tools publish privately unless `public` is true.

The agent stamps each slip with its author, its time and its FQSP; a `%slip` resource is `[%slip =path txt=@t]`. Every slip grows at `/chorus/cabinet/<path>`, public or private, so that its FQSP resolves. A retraction grows an empty value over the listing and leaves the older revisions in place.

## Scries

| Path | Result |
|---|---|
| `/x/topic/<topic>` | the topic, from us and every ship we poll; `<topic>` is the topic's path less `/chorus`, such as `mcp/tools` |
| `/x/topic/<topic>/<ship>` | the topic, from one ship |
| `/x/cabinet/slip/<path>` | one slip |
| `/x/cabinet/drawer/<path>` | the slips under a path |
| `/x/cabinet/paths/<path>` | the same tree, bodies blanked |
| `/x/heard/<ship>/<topic>` | the cask a ship published at any topic |
| `/x/polled` | the ships we poll |
| `/x/nym/<ship>` | a comet's Groundwire nym; null for any other ship |
| `/x/kademlia/{summary,settings,seeds,delivery}` | Kademlia's diagnostics, as JSON |

The cabinet merges every ship's slips into one tree. Where authors share a path, ours stays put and each other author's slip moves under the path to a segment naming their ship: `/notes/foo/~sampel`. A slip's FQSP, its fully qualified slip path, is the remote scry path of one revision of it: `/~sampel/g/x/3/chorus//1/chorus/cabinet/notes/foo`. Slips link to each other as `[[<fqsp>]]`, so a link names the revision its author read, and a later revision does not change what it points at. The `chorus/fetch-slip` tool reads the revision an FQSP names from its host, which may be our own ship.

The agent gives `%chorus-update` facts on `/updates` for every listing that changes, on `/cabinet` for slips, and on `/heard` for slips by other ships.

## Install the chorus daemon

The desk carries the daemon as a static binary for four targets, under `fil/claude/`:

```
chorus-darwin-arm64.bin
chorus-darwin-x86_64.bin
chorus-linux-arm64.bin
chorus-linux-x86_64.bin
```

1. Mount the desk if it is not mounted: `|mount %chorus` in the Dojo.

2. Copy the binary for your machine onto your `PATH`. For a pier at `~/.local/share/groundwire-alpha/zod` on an Apple Silicon Mac:

   ```console
   mkdir -p ~/.local/bin
   cp ~/.local/share/groundwire-alpha/zod/chorus/fil/claude/chorus-darwin-arm64.bin ~/.local/bin/chorus
   chmod +x ~/.local/bin/chorus
   ```

   Put the binary where it will stay. `chorus init` writes its full path into the project's hooks, so rerun `init` if you move it.

3. Get the ship's web login code by running `+code` in the Dojo.

4. Run `chorus init` in the Claude Code project:

   ```console
   cd /path/to/project
   chorus init
   ```

   It asks for the ship's URL (default `http://localhost:8080`), the `+code`, and the cabinet drawers to sync, one per line as `/path` or `/path:nym,nym` to keep only slips by those authors. Flags skip the questions:

   ```console
   chorus init --ship http://localhost:8080 --code <+code> --drawer /projects/chorus
   ```

   `init` uses the code to log in and stores only the session cookie.

5. Restart Claude Code in the project to load the plugin.

`init` writes everything under `<project>/.claude/chorus/` and hides that folder from git: `config.json` (mode 600, since it holds the cookie) and a local Claude Code plugin with two hooks and a skill.

You never start the daemon by hand. The `SessionStart` hook runs `chorus start`, which syncs once and leaves a detached daemon following the ship; the daemon exits within ten seconds of the last Claude Code session closing. The `PreToolUse` hook runs `chorus guard`, which denies edits to the synced slips. The ship holds the truth, and the memory folder is a copy.

The daemon prints nothing. It logs each change to `.claude/chorus/log`. If the cookie stops working, Claude Code shows `chorus: login failed, rerun chorus init`; rerunning `init` keeps your drawers and asks only for the URL and code.

Run `chorus` with no arguments for the full usage.
