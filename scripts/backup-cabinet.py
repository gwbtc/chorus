#!/usr/bin/env python3
"""one-off: pull every slip out of a ship's chorus cabinet into a folder.

usage: backup-cabinet.py [out-dir]

reads the ship url and cookie from .claude/chorus/config.json; the
cookie is never written to the backup.
"""

import json
import sys
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONFIG = ROOT / ".claude" / "chorus" / "config.json"


class NoRedirect(urllib.request.HTTPRedirectHandler):
    # eyre answers a stale cookie with a redirect to the login page
    def redirect_request(self, *args, **kwargs):
        return None


def scry(ship, cookie, path):
    url = f"{ship}/~/scry/chorus{path}.json"
    req = urllib.request.Request(url, headers={"cookie": cookie})
    opener = urllib.request.build_opener(NoRedirect)
    try:
        with opener.open(req, timeout=60) as res:
            return res.read()
    except urllib.error.HTTPError as err:
        if err.code in (301, 302, 303, 307, 308, 401, 403):
            sys.exit(f"unauthorized ({err.code}): refresh the cookie in {CONFIG}")
        sys.exit(f"scry {path} failed: {err.code}")


def walk(node, path, out):
    # same traversal as walk() in sync/ship.zig
    if node.get("slip") is not None:
        out.append((path, node["slip"]))
    for seg, kid in sorted((node.get("dir") or {}).items()):
        walk(kid, f"{path}/{seg}", out)


def main():
    out_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "cabinet-backup"
    config = json.loads(CONFIG.read_text())
    ship = config["ship"].rstrip("/")
    cookie = config["cookie"]

    raw = scry(ship, cookie, "/cabinet/drawer")
    slips = []
    walk(json.loads(raw), "", slips)

    paths = []
    walk(json.loads(scry(ship, cookie, "/cabinet/paths")), "", paths)
    if sorted(p for p, _ in slips) != sorted(p for p, _ in paths):
        sys.exit(f"drawer has {len(slips)} slips but paths has {len(paths)}")

    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "cabinet.json").write_bytes(raw)

    manifest = []
    for path, slip in slips:
        body = out_dir / "slips" / (path.lstrip("/") + ".md")
        body.parent.mkdir(parents=True, exist_ok=True)
        body.write_text(slip["text"])
        manifest.append({"path": path, **slip})

    (out_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")

    for path, slip in slips:
        print(f"{slip['ship']:>16}  {len(slip['text']):>5}  {path}")
    print(f"{len(slips)} slips saved to {out_dir}")


if __name__ == "__main__":
    main()
