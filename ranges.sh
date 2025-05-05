#!/bin/bash

exec 3>&1 4>&2

P() { TZ=UTC date '+%Y-%m-%dT%H:%M:%SZ'; }
L() { printf '[%s][%s] %s\n' "$(basename "$0")" "$(P)" "$*" >&3; }
E() { printf '[%s][%s] ERROR: %s\n' "$(basename "$0")" "$(P)" "$*" >&4; }

uname | grep -qi 'SunOS' && {
    E "Solaris not supported. Exiting."
    exit 99
}

_r() { awk 'BEGIN{srand();print int(rand()*32768)}'; }
TMPDIR="$(mktemp -d "/tmp/.r.$$.$(_r).XXXXXXXX")" || exit 1
[ -d "$TMPDIR" ] || exit 1

cleanup() { rm -rf -- "$TMPDIR"; }
trap 'cleanup' EXIT HUP INT QUIT TERM

_resolve() {
    getent hosts "$1" >/dev/null 2>&1 && return 0
    host "$1" >/dev/null 2>&1 && return 0
    return 1
}

_fetch_json_ipv4() {
    _url="$1"
    _out="$2"
    _desc="$3"

    for _i in 1 2 3; do
        curl -s --max-time 10 "$_url" -o "$TMPDIR/tmp.json" && break
        sleep 5
    done

    [ -s "$TMPDIR/tmp.json" ] || {
        E "Failed to fetch $_desc"
        return
    }

    jq -e . "$TMPDIR/tmp.json" >/dev/null 2>&1 || {
        E "Invalid JSON received for $_desc"
        return
    }

    jq -r '.. | strings | select(test("^[0-9./]+$"))' "$TMPDIR/tmp.json" |
        grep -v ':' |
        sort -Vu | grep "/" > "$_out"
}

_fetch_cloudflare() {
    _resolve api.cloudflare.com || { E "cloudflare DNS fail"; return; }
    L "Fetching Cloudflare IP ranges..."
    curl -s --max-time 10 "https://api.cloudflare.com/client/v4/ips" -o "$TMPDIR/cf.json" || return
    jq -e . "$TMPDIR/cf.json" >/dev/null 2>&1 || {
        E "Invalid JSON received for Cloudflare"
        return
    }
    jq -r '.result.ipv4_cidrs[]' "$TMPDIR/cf.json" | sort -Vu > cloudflare.txt
}

_fetch_google() {
    _resolve www.gstatic.com || { E "google DNS fail"; return; }
    L "Fetching Google IP ranges..."
    curl -s --max-time 10 "https://www.gstatic.com/ipranges/cloud.json" -o "$TMPDIR/g.json" || return
    jq -e . "$TMPDIR/g.json" >/dev/null 2>&1 || {
        E "Invalid JSON received for Google"
        return
    }
    jq -r '.prefixes[].ipv4Prefix' "$TMPDIR/g.json" | sort -Vu > google.txt
}

_fetch_aws() {
    _resolve ip-ranges.amazonaws.com || { E "aws DNS fail"; return; }
    L "Fetching AWS IP ranges..."
    _fetch_json_ipv4 "https://ip-ranges.amazonaws.com/ip-ranges.json" aws.txt "AWS IP ranges"
}

_fetch_scaleway() {
    _resolve www.scaleway.com || { E "scaleway DNS fail"; return; }
    L "Fetching Scaleway IP ranges..."
    curl -s --max-time 10 "https://www.scaleway.com/en/docs/account/reference-content/scaleway-network-information/#ipv4" |
        grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]+' |
        sort -Vu > scaleway.txt
}

_fetch_linode() {
    _resolve speedtest.newark.linode.com || { E "linode DNS fail"; return; }
    L "Fetching Linode IP ranges..."
    curl -s --max-time 10 "https://geoip.linode.com/" |
        grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]+' |
        sort -Vu > linode.txt
}

_fetch_oracle() {
    _resolve docs.oracle.com || { E "oracle DNS fail"; return; }
    L "Fetching Oracle IP ranges..."
    curl -s --max-time 10 "https://docs.oracle.com/en-us/iaas/tools/public_ip_ranges.json" -o "$TMPDIR/oracle.json" || return
    jq -e . "$TMPDIR/oracle.json" >/dev/null 2>&1 || {
        E "Invalid JSON received for Oracle Cloud"
        return
    }
    jq -r '.. | objects | .cidr? // empty' "$TMPDIR/oracle.json" |
        grep -v ':' |
        sort -Vu > oracle.txt
}

_fetch_ibm() {
    _resolve check.torproject.org || { E "torproject DNS fail"; return; }
    L "Fetching IBM (Tor exit) IP ranges..."
    curl -s --max-time 10 "https://check.torproject.org/exit-addresses" |
        awk '/^ExitAddress/ { print $2 }' |
        sort -Vu > ibm.txt
}

_fetch_microsoft() {
    L "Fetching Microsoft IP ranges..."

    for ID in 56519 57063 57064 57062; do
        PAGE="https://www.microsoft.com/en-us/download/details.aspx?id=$ID"
        curl -s "$PAGE" | sed -nE 's/.*<a href=["'\''"]([^"'\''"]*ServiceTags_[^"'\''"]*\.json)["'\''"].*/\1/p' |
            head -1 |
            while read -r URL; do
                curl -s --max-time 20 "$URL" -o "$TMPDIR/ms.json"
                jq -e . "$TMPDIR/ms.json" >/dev/null 2>&1 || {
                    E "Invalid JSON received for Microsoft"
                    continue
                }
                jq -r '.values[].properties.addressPrefixes[]?' "$TMPDIR/ms.json" | grep -v ':' >> "$TMPDIR/ms-ipv4.txt"
            done
    done

    sort -Vu "$TMPDIR/ms-ipv4.txt" > microsoft.txt
}

main() {
    L "Starting..."

    _fetch_google
    _fetch_cloudflare
    _fetch_aws
    _fetch_scaleway
    _fetch_linode
    _fetch_oracle
    _fetch_ibm
    _fetch_microsoft

    L "Ranges complete"
    exit 0
}

main "$@"
