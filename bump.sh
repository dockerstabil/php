#!/bin/bash
# see http://www.gnu.org/s/bash/manual/html_node/The-Set-Builtin.html
set -o errexit  # exit on [ $? != 0 ]
set -o nounset  # exit on uninitialized vars
set -o pipefail # exit on pipeline errors

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
	echoError "\t$BASH_SOURCE PHP_VERSION"
	echoError ""
	echoError "example:"
	echoError "\t$BASH_SOURCE 7.2.5"
}

if [ $# -ne 1 ]; then
	echoErrorUsage "Wrong number of arguments (given $#, expected 1)"
	exit 2
fi
export PHP_VERSION=$1

patch=$(git tag | ( grep -s "^$PHP_VERSION-" || true) | sed "s/^$PHP_VERSION-//" | sort | tail -n1)
if [ -n "$patch" ]; then
	patch="-$((patch + 1))"
fi

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

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


for tpl in Dockerfile.*.tpl; do
	dest_dir=${tpl%.tpl}
	dest_dir=${dest_dir#Dockerfile.}
	docker_file="$dest_dir/Dockerfile"
	"$envy_cmd" --output="$docker_file" --input="$tpl" *.tpl *.inc
	git add "$dest_dir"
done

git commit -m "$PHP_VERSION$patch"
git tag "$PHP_VERSION$patch"
