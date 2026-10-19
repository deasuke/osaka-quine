#!/bin/sh
set -eu
cd "$(dirname "$0")"
generated=$(mktemp "${TMPDIR:-/tmp}/tokyo-quine.XXXXXX")
trap 'rm -f "$generated"' EXIT HUP INT TERM
ruby tokyo-maker.rb > "$generated"
ruby -c "$generated"
mv "$generated" tokyo.rb
ruby test-tokyo.rb
