#!/usr/bin/env bash

set -euo pipefail

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${current_dir}/.." && pwd)"

surfpool_home="${repo_root}/.surfpool"
surfpool_bin="${surfpool_home}/bin"

mkdir -p "${surfpool_bin}"

echo "Installing Surfpool..."

tmp_dir="$(mktemp -d)"

cleanup() {
    rm -rf "${tmp_dir}"
}
trap cleanup EXIT

installer="${tmp_dir}/install-surfpool.sh"

curl \
    --fail \
    --silent \
    --show-error \
    --location \
    https://run.surfpool.run/ \
    --output "${installer}"

chmod +x "${installer}"

#
# Run the official installer.
#
bash "${installer}"

#
# Find the installed Surfpool binary.
#
surfpool_source=""

for candidate in \
    "${HOME}/.local/bin/surfpool" \
    "${HOME}/.local/share/surfpool/bin/surfpool" \
    "${HOME}/.surfpool/bin/surfpool"
do
    if [ -x "${candidate}" ]; then
        surfpool_source="${candidate}"
        break
    fi
done

if [ -z "${surfpool_source}" ]; then
    surfpool_source="$(command -v surfpool 2>/dev/null || true)"
fi

if [ -z "${surfpool_source}" ] || [ ! -x "${surfpool_source}" ]; then
    echo "Unable to locate installed Surfpool binary."
    exit 1
fi

echo
echo "Moving Surfpool into repo-local installation..."

cp "${surfpool_source}" "${surfpool_bin}/surfpool"
chmod +x "${surfpool_bin}/surfpool"

echo
echo "Installed:"
"${surfpool_bin}/surfpool" --version

echo
echo "Surfpool home:"
echo "${surfpool_home}"

echo
echo "Done."