#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for talhelper.
repository="budimanjojo/talhelper"
GH_REPO="https://github.com/$repository"
TOOL_NAME="talhelper"
TOOL_TEST="talhelper --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if talhelper is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi


# get the OS family name
get_os() {
  uname | tr '[:upper:]' '[:lower:]'
}

# get the cpu architecture
get_arch() {
  local -r arch=$(uname -m)

  case $arch in
  x86_64)
    echo amd64
    ;;
  aarch64)
    echo arm64
    ;;
  *)
    # e.g. "arm64"
    echo $arch
    ;;
  esac
}


get_release_talosctl_asset_name() {
  local -r os=$(get_os)
  local -r arch=$(get_arch)

  echo "${TOOL_NAME}_${os}_${arch}.tar.gz"
}


sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_releases() {
  url="https://api.github.com/repos/$repository/releases"
  curl "${curl_opts[@]}" -C - "$url" | grep tag_name | sed 's/"tag_name": //g;s/"//g;s/,//g;s/v//g' || fail "Could get release informations from $url"
}


list_all_versions() {
  # TODO: Adapt this. By default we simply list the tag names from GitHub releases.
  # Change this function if talhelper has other means of determining installable versions.
  list_github_tags
}

get_download_url() {
  local version filename
  version="$1"
  filename="$2"

  echo "$GH_REPO/releases/download/v$version/$filename"
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  # TODO: Adapt the release URL convention for talhelper
  url="$(get_download_url $version $(get_release_talosctl_asset_name))"


  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    # TODO: Assert talhelper executable exists.
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
