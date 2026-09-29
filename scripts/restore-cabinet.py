#!/usr/bin/env python3
"""one-off: publish the slips of a cabinet backup back to the ship.

usage: restore-cabinet.py [backup-dir]

reads the manifest that backup-cabinet.py wrote, and the ship url and
cookie from .claude/chorus/config.json. republishes our own slips
through the chorus/publish-slip mcp tool, each with the time it was
first written. slips by other ships are skipped: they come back when
we poll their authors.
"""

import json
import re
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONFIG = ROOT / ".claude" / "chorus" / "config.json"

# [[/~host/g/x/<rev>/chorus//1/cabinet/<path>]], the old link form
FQSP = re.compile(r"\[\[/(~[a-z-]+)/g/x/\d+/chorus//1/cabinet(/[^\]]+)\]\]")


def call(ship, cookie, tool, args):
    body = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "tools/call",
        "params": {"name": tool, "arguments": args},
    }
    req = urllib.request.Request(
        f"{ship}/mcp",
        data=json.dumps(body).encode(),
        headers={
            "content-type": "application/json",
            "accept": "application/json, text/event-stream",
            "cookie": cookie,
        },
    )
    with urllib.request.urlopen(req, timeout=120) as res:
        text = res.read().decode()
    # the server may answer as one server-sent event
    for line in text.splitlines():
        if line.startswith("data:"):
            text = line[len("data:"):]
    reply = json.loads(text)
    if "error" in reply:
        return False, reply["error"]
    result = reply.get("result", {})
    return not result.get("isError", False), result


def main():
    backup = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "cabinet-backup"
    config = json.loads(CONFIG.read_text())
    ship = config["ship"].rstrip("/")
    cookie = config["cookie"]
    our = cookie.split("=")[0].removeprefix("urbauth-")

    manifest = json.loads((backup / "manifest.json").read_text())
    failed = 0
    for slip in manifest:
        if slip["ship"] != our:
            print(f"skipped   {slip['path']} (by {slip['ship']})")
            continue
        text = FQSP.sub(r"[[/\1\2]]", slip["text"])
        ok, result = call(
            ship,
            cookie,
            "chorus/publish-slip",
            {"path": slip["path"], "text": text, "created": slip["created"]},
        )
        if ok:
            print(f"restored  {slip['path']}")
        else:
            failed += 1
            print(f"FAILED    {slip['path']}: {json.dumps(result)[:300]}")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
