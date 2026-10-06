# Polling notes

Two questions about how chorus polls, set aside on 2026-10-06 to come back to.

## Nine pointers a poll

A poll asks each ship for nine names, one per reserved topic: `+poll-ship` in `desk/app/chorus.hoon` calls `+get` for every topic in `+topics`.
Each `+get` is a `%get` of a name, which is a pointer lookup in the DHT, and each answer is a separate event.
Between Aqua ships one poll takes about thirty seconds.

A ship could publish one root index instead: a map from topic to the digest of that topic's shelf, under one name.
A poll would then be one pointer lookup per ship.
An unchanged root digest would end the poll there, and a changed one would name the shelves to fetch by digest.

The cost is one more value to publish and keep in step: every publish and retraction would put the shelf and then the root.
The root would also need its own vetting rule, and `+renew` would renew ten values where it now renews nine.

## Unused topic advertisements

Every shelf chorus publishes also advertises itself in content discovery, and nothing reads the advertisements.

`+put` in `desk/app/chorus.hoon` passes the content store a topic publication with every named `%put`: the topic path, the shelf's mark as the catalog format, the number of entries, and the time as the revision.
That covers all nine topics: `/chorus/desks`, `/chorus/rolodex`, `/chorus/announcements`, `/chorus/cabinet`, `/chorus/skills`, `/chorus/mcp/tools`, `/chorus/mcp/prompts`, `/chorus/mcp/resources` and `/chorus/mcp/resources/templates`.
`+renew` publishes them again every twelve hours.
`+stow`, which publishes a tool's source or a skill's manifest by digest, advertises nothing.

No code in the desk sends `%search`, the content store command that browses a topic, so no ship ever finds another through these records.
Chorus hears only the ships in `polled`, and it reads each by name.

The advertisements would earn their keep if chorus let a ship find strangers: "who publishes skills?" is a `%search` of `/chorus/skills`.
Until something does that, each `%put` pays for a discovery record that nobody reads, and chorus could publish with `with-name` alone.
