#!/usr/bin/env bash

set -e

msg() {
	{
		$color setaf $1
		$color bold
		printf "$2"
		$color sgr0
		shift 2
		printf '%s' "$@"
		printf '\n'
	} >&2
}
error() {
	msg 1 'error: ' "$@"
}

warn() {
	msg 3 'warning: ' "$@"
}

usage() {
	cat >&2 <<EOM
Usage: $0 <PACKAGE>

Set up CI for a new package.
Run this from this repo's root, and give the name of one of the packages.

OPTIONS
    --color=ENABLE  Enable color in output. Defaults to enabled. Valid values
                      are "on", "always", "yes", "off", "never", and "no".
    -f, --force     Overwrite an existing destination file.
    -h, --help      Print this message.
EOM
}

force=false
color=tput

TEMP=$(getopt -o 'fh' -l 'color:,force,help' -n "$0" -- "$@")
eval set -- "$TEMP"
unset TEMP
while true; do
	case "$1" in
		--color)
			case "$2" in
				on|always|yes)
					color=tput
				;;
				off|never|no)
					color=true
				;;
				*)
					error "Invalid argument to \`--color\` \"$2\""
					exit 1
			esac
			shift 2
		;;
		-f|--force)
			force=true
			shift
		;;
		-h|--help)
			usage
			exit 0
		;;
		--)
			shift
			break
		;;
		*)
			printf 'Internal error!? (`getopt` returned "%s")\n' "$1" >&2
			exit 1
		;;
	esac
done

if [ $# -ne 1 ]; then
	usage
	exit 1
fi

if ! [[ -e .git ]]; then
	warn "This does not appear to be the repo's root"
fi

if [[ "$1" == */* ]]; then
	error "Package name \"$1\" cannot contain slashes"
	exit 1
fi

mkdir -p .github/workflows
outfile=".github/workflows/$1.yml"

if ! $force && [[ -e "$outfile" ]]; then
	error "Not overwriting \"$outfile\" unless \`-f\` is given"
	exit 1
fi

if ! [[ -e "$1" ]]; then
	warn "Package \"$1\" not present in repo"
elif ! [[ -d "$1" ]]; then
	warn "Package \"$1\" is not a directory"
fi

cat >".github/workflows/$1.yml" <<EOF
name: $1
on:
  push:
    paths:
        - "$1/**"
  pull_request:
    paths:
        - "$1/**"
  workflow_dispatch:

jobs:
  pkgbuild:
    runs-on: ubuntu-20.04
    steps:
    - name: Checkout repo
      uses: actions/checkout@v2
    - name: Build package
      id: makepkg
      uses: edlanglois/pkgbuild-action@v1
      with:
        pkgdir: "$1"
    - name: Upload package
      uses: actions/upload-artifact@v2
      with:
          path: \${{ steps.makepkg.outputs.pkgfile0 }}
EOF
