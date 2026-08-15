#!/usr/bin/env bash

set -euo pipefail

SPL_TOKEN_VERSION="5.6.1"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${current_dir}/.." && pwd)"
cargo_root="${repo_root}/.cargo"

mkdir -p "${cargo_root}"

echo "Installing spl-token-cli ${SPL_TOKEN_VERSION}..."

cargo install \
    --version "${SPL_TOKEN_VERSION}" \
    --root "${cargo_root}" \
    spl-token-cli \
    >/dev/null 2>&1 || true

spl_source="$(find "${HOME}/.cargo/registry/src" \
    -maxdepth 2 \
    -type d \
    -name "spl-token-cli-${SPL_TOKEN_VERSION}" \
    -print \
    -quit)"

if [ -z "${spl_source}" ]; then
    echo "Unable to locate spl-token-cli ${SPL_TOKEN_VERSION} source."
    exit 1
fi

cd "${spl_source}"

cargo update -p ring@0.17.13 --precise 0.17.14 2>/dev/null || true

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
                --locked \
                --path . \
                --root "${cargo_root}"
        ;;

    Linux)
        cargo install \
            --locked \
            --path . \
            --root "${cargo_root}"
        ;;

    *)
        echo "Unsupported OS: $(uname -s)"
        exit 1
        ;;
esac

"${cargo_root}/bin/spl-token" --version
