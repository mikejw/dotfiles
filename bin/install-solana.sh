#!/usr/bin/env bash

set -euo pipefail

SOLANA_VERSION="3.1.10"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${current_dir}/.." && pwd)"

install_root="${repo_root}/.solana"
release_dir="${install_root}/release"

mkdir -p "${install_root}"

os="$(uname -s)"
arch="$(uname -m)"

case "${os}" in
    Darwin)
        case "${arch}" in
            arm64)
                target="aarch64-apple-darwin"
                ;;
            x86_64)
                target="x86_64-apple-darwin"
                ;;
            *)
                echo "Unsupported macOS architecture: ${arch}"
                exit 1
                ;;
        esac
        ;;

    Linux)
        case "${arch}" in
            x86_64)
                target="x86_64-unknown-linux-gnu"
                ;;
            aarch64|arm64)
                target="aarch64-unknown-linux-gnu"
                ;;
            *)
                echo "Unsupported Linux architecture: ${arch}"
                exit 1
                ;;
        esac
        ;;

    *)
        echo "Unsupported OS: ${os}"
        exit 1
        ;;
esac

archive="solana-release-${target}.tar.bz2"
url="https://github.com/anza-xyz/agave/releases/download/v${SOLANA_VERSION}/${archive}"

tmp_dir="$(mktemp -d)"

cleanup() {
    rm -rf "${tmp_dir}"
}
trap cleanup EXIT

echo "Installing Solana ${SOLANA_VERSION}"
echo "Target: ${target}"

curl \
    --fail \
    --location \
    --output "${tmp_dir}/${archive}" \
    "${url}"

rm -rf "${release_dir}"

tar \
    -xjf "${tmp_dir}/${archive}" \
    -C "${tmp_dir}"

mv "${tmp_dir}/solana-release" "${release_dir}"

ln -sfn "${release_dir}/bin" "${install_root}/bin"

echo
echo "Installed:"
"${install_root}/bin/solana" --version

echo
echo "Install directory:"
echo "${install_root}"
