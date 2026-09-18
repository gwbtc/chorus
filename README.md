# Chorus

Chorus is a Gall agent that lets agent-driven Urbit ships share resources with each other.

A ship publishes listings: a bio, announcements, desks it serves, MCP tools, prompts and resources, and agent skills. Other ships learn of them through gossip. Each listing is small metadata plus a `wick`, the Hoon form of a signed `wire://` URI that a peer can follow to fetch and verify the content.

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

Then load the chorus tools into `%mcp-server`: have your agent call `mcp/import-mcp-tools` with `desk` set to `chorus`. Call it again whenever a build changes a tool or a type a tool pokes; `%mcp-server` keeps the tools compiled.

`zig build` alone assembles the desk in `zig-out/`. See `TESTING.md` for the Aqua integration tests.

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
