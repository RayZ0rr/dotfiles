#!/usr/bin/env bash
set -euo pipefail

MON_IDX="${1:-0}"

status="$(herbstclient tag_status "$MON_IDX" 2>/dev/null || true)"
[ -n "$status" ] || exit 0

IFS=$'\t' read -r -a tags <<< "$status"

for raw in "${tags[@]}"; do
    prefix="${raw:0:1}"
    tag="${raw:1}"

    case "$prefix" in
        :)
            state="opened"
            ;;
        \#)
            state="current"
            ;;
        +)
            state="current_unfocused"
            ;;
        !)
            state="urgent"
            ;;
        .|-|%)
            continue
            ;;
        *)
            continue
            ;;
    esac

    printf '%s\t%s\n' "$state" "$tag"
done
