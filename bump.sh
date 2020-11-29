#!/bin/bash
# see http://www.gnu.org/s/bash/manual/html_node/The-Set-Builtin.html
set -o errexit  # exit on [ $? != 0 ]
set -o nounset  # exit on uninitialized vars
set -o pipefail # exit on pipeline errors

LATEST_PHP_VERSION=$(git tag | ( grep -vs "-" || true ) | sort | tail -n1)
GIT_COMMIT=${GIT_COMMIT:-true}

echoInfo () {
  echo -e "\033[1;94m[info]\033[0m $*"
}

echoError () {
  echo >&2 -e "\033[1;31m[error]\033[0m $*"
}

echoErrorUsage () {
	if [ $# -gt 0 ]; then
		echoError "$1"
		echoError ""
	fi
	echoError "usage:"
	echoError "\t[ENV] $BASH_SOURCE PHP_VERSION"
	echoError ""
	echoError "ENV:"
	echoError "\t GIT_COMMIT  create git commit (default: true)"
	echoError ""
	echoError "examples:"
	echoError "\t$BASH_SOURCE $LATEST_PHP_VERSION"
	echoError "\tGIT_COMMIT=false $BASH_SOURCE $LATEST_PHP_VERSION"
}

if [ $# -ne 1 ]; then
	echoErrorUsage "Wrong number of arguments (given $#, expected 1)"
	exit 2
elif [ "$1" = "-h" ]; then
	echoErrorUsage
	exit 0
fi
export PHP_VERSION=$1

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"


# verify envy is available
if [ -x ./envy ]; then
	envy_cmd=./envy
elif command -v envy >/dev/null 2>&1; then
	envy_cmd=envy
else
	echoError "envy command not found"
	echoError
	echoError "Download Page:"
	echoError "https://github.com/schnittstabil/envy/releases"
	exit 3
fi


# bump Dockerfiles
for tpl in Dockerfile.*.tpl; do
	dest_dir=${tpl%.tpl}
	dest_dir=${dest_dir#Dockerfile.}
	docker_file="$dest_dir/Dockerfile"

	"$envy_cmd" --output="$docker_file" --input="$tpl" *.tpl *.inc
	[ "$GIT_COMMIT" = true ] && git add "$dest_dir"
done


# bump readme
"$envy_cmd" --output="readme.md" "readme.tpl.md"
[ "$GIT_COMMIT" = true ] && git add "readme.md"


# create git tag and commit
if [ "$GIT_COMMIT" = true ]; then
	if [ -n "$(git tag | grep -s "^$PHP_VERSION")" ]; then
		patch=$(git tag | ( grep -s "^$PHP_VERSION" || true) | sed "s/^$PHP_VERSION-\?//" | sort | tail -n1)
		patch="-$((patch + 1))"
	else
		patch=""
	fi

	if [ -n "$(git status --porcelain)" ]; then
		git commit -m "$PHP_VERSION$patch"
	fi

	git tag "$PHP_VERSION$patch"
fi
