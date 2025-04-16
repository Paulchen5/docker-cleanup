#!/bin/bash

# Sicher starten
set -o errexit
set -o nounset
set -o pipefail

show_help() {
  echo "Usage: docker cleanup"
  echo
  echo "Removes all dangling (unused) Docker images."
}

show_version() {
  echo "docker-cleanup version 1.0.0"
}

cleanup_images() {
  local trash
  trash=$(docker images --filter "dangling=true" --quiet)

  if [ -z "$trash" ]; then
    echo "✅ No unused (dangling) images found."
  else
    echo "🧹 Removing the following dangling images:"
    echo "$trash"
    echo "$trash" | xargs -r docker rmi
  fi
}

main() {
    if [[ "${1:-}" == cleanup* ]]; then
        set -- "${@:2}"
    fi

    case "${1:-}" in
        docker-cli-plugin-metadata)
            cat << EOF
{
    "SchemaVersion": "0.1.0",
    "Vendor": "Paulchen <lukas.23022005@gmail.com>",
    "Version": "v0.1.0",
    "ShortDescription": "Removes all dangling (unused) Docker images"
}
EOF
            exit 0
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        --version|-v)
            show_version
            exit 0
            ;;
        *)
            echo "${1:-}"
            cleanup_images
            ;;
    esac
}

# Main function
{
    main "$@"
} 2>/dev/null
