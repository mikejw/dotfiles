#!/usr/bin/env bash

set -euo pipefail

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${current_dir}/.." && pwd)"

rustup_home="${repo_root}/.rustup"
cargo_home="${repo_root}/.rustup-cargo"
rustup_link="${repo_root}/bin/rustup"

mkdir -p \
    "${rustup_home}" \
    "${cargo_home}" \
    "${repo_root}/bin"

export RUSTUP_HOME="${rustup_home}"
export CARGO_HOME="${cargo_home}"
export RUSTUP_INIT_SKIP_PATH_CHECK=yes

echo "Installing rustup..."

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- \
        -y \
        --profile minimal \
        --default-toolchain none \
        --no-modify-path

echo
echo "Creating rustup symlink..."

ln -sf "${CARGO_HOME}/bin/rustup" "${rustup_link}"

echo
echo "Installed:"
"${CARGO_HOME}/bin/rustup" --version

echo
echo "RUSTUP_HOME:"
echo "${RUSTUP_HOME}"

echo
echo "CARGO_HOME:"
echo "${CARGO_HOME}"

echo
echo "Rustup command:"
echo "${rustup_link}"

echo
echo "Done."
