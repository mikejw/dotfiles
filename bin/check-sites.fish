#!/usr/bin/env fish

# HTTP site checker.
#
# The site list is intentionally NOT stored in this repo.
#
# Configure the list once per machine using a Fish universal variable:
#
#   set -U site_check_urls \
#       https://example.com \
#       https://another.example.com
#
# View the configured sites:
#
#   printf '%s\n' $site_check_urls
#
# Add another site:
#
#   set -Ua site_check_urls https://newsite.example.com
#
# Remove a site:
#
#   set -U site_check_urls \
#       (string match -v 'https://oldsite.example.com' $site_check_urls)
#
# Replace the entire list:
#
#   set -U site_check_urls \
#       https://example.com \
#       https://another.example.com
#
# Delete the variable entirely:
#
#   set -eU site_check_urls
#
# Universal variables persist across Fish sessions on this machine.

if not set -q site_check_urls
    echo "No sites configured."
    echo
    echo "Set them with:"
    echo
    echo "  set -U site_check_urls https://example.com https://another.example.com"
    exit 1
end

for site in $site_check_urls
    set http_status (curl \
        --silent \
        --location \
        --output /dev/null \
        --write-out "%{http_code}" \
        --connect-timeout 10 \
        --max-time 30 \
        $site)

    if test "$http_status" = "200"
        echo "✓ $site — $http_status"
    else
        echo "✗ $site — $http_status"

        set domain (string replace -r '^https?://(www\.)?' '' $site)

        if type -q say
            say "Warning. $domain returned HTTP status $http_status"
        end
    end
end
