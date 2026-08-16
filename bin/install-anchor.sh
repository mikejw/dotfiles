#!/usr/bin/env bash

set -euo pipefail

ANCHOR_VERSION="1.0.0"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${current_dir}/.." && pwd)"

avm_home="${repo_root}/.avm"

mkdir -p "${avm_home}"

export AVM_HOME="${avm_home}"
export PATH="${AVM_HOME}/bin:${PATH}"

echo "Installing AVM..."

case "$(uname -s)" in
    Darwin)
        env \
            -u NIX_CFLAGS_COMPILE \
            -u NIX_CFLAGS_COMPILE_FOR_BUILD \
            -u NIX_ENFORCE_PURITY \
            -u NIX_ENFORCE_NO_NATIVE \
            -u NIX_HARDENING_ENABLE \
            -u NIX_CC \
            -u NIX_CC_FOR_BUILD \
            -u NIX_BINTOOLS \
            -u NIX_BINTOOLS_FOR_BUILD \
            -u SDKROOT \
            -u DEVELOPER_DIR \
            CC=/usr/bin/clang \
            CXX=/usr/bin/clang++ \
            cargo install \
                --git https://github.com/solana-foundation/anchor \
                avm \
                --locked \
                --root "${AVM_HOME}" \
                --force
        ;;

    Linux)
        cargo install \
            --git https://github.com/solana-foundation/anchor \
            avm \
            --locked \
            --root "${AVM_HOME}" \
            --force
        ;;

    *)
        echo "Unsupported OS: $(uname -s)"
        exit 1
        ;;
esac

echo
echo "Installing Anchor ${ANCHOR_VERSION}..."

avm install "${ANCHOR_VERSION}"
avm use "${ANCHOR_VERSION}"

echo
echo "Installed versions:"
avm --version
anchor --version

echo
echo "AVM home:"
echo "${AVM_HOME}"

echo
echo "Done."
