#!/usr/bin/env bats
#
# Decode the QR we generate and assert it carries the exact pairing payload.
# Covers the canonical PNG plus both inline-image renderers (Kitty, iTerm2),
# proving the protocol framing doesn't corrupt the embedded QR. The block
# (ANSIUTF8) render is the same matrix from qrencode, so the PNG test covers
# its content; only its on-screen pixels differ.

setup() {
    source "${BATS_TEST_DIRNAME}/../bin/adbqr"
    PAYLOAD="WIFI:T:ADB;S:adbqr-test;P:424242;;"
    TMP="$(mktemp -t adbqr-test.XXXXXX)"
}

teardown() {
    rm -f "$TMP"
}

# Decode a PNG QR file to its raw text content.
decode() {
    zbarimg --quiet --raw "$1" | tr -d '\n'
}

@test "the generated PNG QR decodes to the pairing payload" {
    qrencode -m 2 -s 8 -o "$TMP" -t PNG "$PAYLOAD"
    [ "$(decode "$TMP")" = "$PAYLOAD" ]
}

@test "the Kitty-protocol image carries a QR that decodes to the payload" {
    render_inline_kitty \
        | perl -0777 -ne 'while (/\033_G[^;]*;([A-Za-z0-9+\/=]*)\033\\/g) { print $1 }' \
        | openssl enc -base64 -d -A > "$TMP"
    [ "$(decode "$TMP")" = "$PAYLOAD" ]
}

@test "the iTerm2-protocol image carries a QR that decodes to the payload" {
    render_inline_iterm2 \
        | perl -0777 -ne 'print $1 if /:([A-Za-z0-9+\/=]+)\a/' \
        | openssl enc -base64 -d -A > "$TMP"
    [ "$(decode "$TMP")" = "$PAYLOAD" ]
}
