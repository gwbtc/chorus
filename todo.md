# Todo

Left open on 2026-10-06, after the cabinet moved from whole slips to stubs and pages (`d3f9692`) and the chorus mod learned to ask for them (`gwbtc/claude-mods` `14b246b`).

## Repos

- [x] `main` in `gwbtc/chorus` and `gwbtc/claude-mods` has a rule that changes go through a pull request. Direct pushes print the rule and land anyway, because the account bypasses it. Turn the rule off or start using it.
- [x] `CLAUDE.md`, `aqua-notes.md` and `cabinet.md` sit untracked in this repo. `CLAUDE.md` describes the stub-and-page design. Commit them or ignore them.
- [x] `build.zig` pins kademlia at `9b08805` on `bm/wrapper`. Merge that branch upstream, or the pin names a commit on a side branch for good.

## Not yet tested for real

- [ ] No ship has fetched a slip from another ship outside Aqua. ~fossyd polls only ~barmul, which lists no slips. Get a second ship onto the new agent with a public slip, trust its author in `/cabinet`, and read the mod's debug log for `fetch:` and `arrived:`.
- [ ] A page that fails its vet when it arrives has unit tests for the vet and for the store's `%evict`, and no end-to-end test. An Aqua guest cannot publish a bad slip through chorus; it would have to grow one directly.
- [ ] A fetch from a host that is offline: check the store's timeout, the `could not fetch` warning, and that the mod asks again each minute and no sooner.
- [x] `chorus/fetch-slips` compiles and was never registered or called through MCP.
  - 2026-10-07: ~fossyd's `%mcp-server` lists both `chorus/fetch-slip` and `chorus/fetch-slips` (`.^(json %gx /=mcp-server=/mcp/tools/chorus/json)`), Claude Code sees both over `bespoke.kazoo.groundwire.me/mcp`, and a call with drawer `/` returned `{"fetching":"/"}`. Nothing to fetch yet: ~fossyd polls only ~barmul, which lists no slips.
  - Raycast's missing `fetch-slips` is a stale manifest on its side; remove and re-add the server there.

## Upgrades

- [x] A new ship and an old ship refuse each other's cabinets by mark. Upgrade Jake's ship, and any other poller of ~fossyd, to `d3f9692` or later.
  - CI/CD is set up such that pushes to gwbtc/chorus:main push to sponsor ~barmul, which automatically upgrades ~fossyd and Jake's ship
- [x] `%mcp-server` keeps tools compiled. On each upgraded ship, import the chorus tools again: `chorus/discard-slip` changed and `chorus/fetch-slips` is new.

## Agent

- [ ] The markdown parser takes about 1.7 seconds a slip. Chorus now runs it once per page, each in its own event, but a publish and a fetched page still pay it. Profile `de:md` on a 2,048-character slip.
- [ ] `chorus/fetch-slip` keens the FQSP itself and neither reads nor fills the content store's cache. Send it through a `%direct` get.
  - 2026-10-07: it now reads `/x/cabinet/paths` first. A listed, held revision is read locally; a listed, unheld one goes through `%chorus-fetch` and the store's `%direct` get; only an unlisted revision (old, or from a ship we do not poll) still keens the host and caches nothing. Live on ~fossyd; the unheld branch is untested until a polled ship lists a slip.
  - Still open: cache unlisted revisions too. Needs an fqsp-to-digest index chorus owns (the store keys by digest or by DHT name) and the keen moved into the agent so it can `+stow` the page.
- [x] Every slip grows its page at its FQSP, private ones too. Check whether a ship that learns or guesses a private slip's path can fetch it by remote scry.
  - Yes they can, this is the intended privacy model: "private" slips are just "unlisted" but can be scried if you give someone the FQSP.
- [x] The content store never drops a cask on its own. Pollers still hold the old whole-cabinet casks, and every revision of every fetched page stays. Decide what evicts them.
  - not worth fixing
- [x] `polling-notes.md`: one root index per ship in place of nine pointers a poll, and the topic advertisements that nothing searches.
  - i think this is a valid point but it's a fundamental complaint about kademlia and not chorus, leave it for now

## Mod

- [x] When an author revises a slip, the old copy leaves memory until the host holds the new text. Keep the old copy until the new one lands.
- [x] The mod looks again five seconds after an ask and then waits for the minute's sync. A fetch that takes six seconds lands a minute late. Back off over a few looks instead.
  - Yeah do 2, 4, 8, 16, 32 etc. seconds
    - Claude Code's SessionEnd hook should kill this ask if this is not the case already
- [x] An ask at a slip's path also fetches that author's slips under it, even in a deeper drawer where the author is untrusted. The texts stay on the host and never reach memory. Decide whether that matters.
  - This is fine: trust travels down the tree, just not up.
