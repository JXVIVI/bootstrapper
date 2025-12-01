#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIRECTORY="$HOME/dotfiles"
CONFIG_DIRECTORY="$HOME/.config"

mkdir -p "$CONFIG_DIRECTORY"

for module_path in "$DOTFILES_DIRECTORY"/*; do
	[ -d "$module_path" ] || continue
	module_name="$(basename "$module_path")"

	# Skip internal dotfiles directories
	case "$module_name" in
	.git | packages)
		continue
		;;
	esac

	# Default mapping: ~/.config/<module>  ->  ~/dotfiles/<module>
	default_destination="$CONFIG_DIRECTORY/$module_name"
	default_source="$module_path"

	ln -sf "$default_source" "$default_destination"
	echo "linked $default_destination -> $default_source"

	# If the module defines extra or overriding symlinks in .symlinks, process them
	symlinks_file="$module_path/.symlinks"
	if [ -f "$symlinks_file" ]; then
		while IFS= read -r raw_line; do
			# Trim leading/trailing whitespace
			trimmed_line="${raw_line#"${raw_line%%[![:space:]]*}"}"
			trimmed_line="${trimmed_line%"${trimmed_line##*[![:space:]]}"}"

			# Skip empty lines and comments
			[ -z "$trimmed_line" ] && continue
			case "$trimmed_line" in
			\#*) continue ;;
			esac

			# Format expected: "source_rel -> destination_rel"
			source_relative="${trimmed_line%%->*}"
			destination_relative="${trimmed_line##*->}"

			# Trim whitespace around the arrow
			source_relative="$(echo "$source_relative" | xargs)"
			destination_relative="$(echo "$destination_relative" | xargs)"

			source_absolute="$HOME/$source_relative"
			destination_absolute="$HOME/$destination_relative"

			mkdir -p "$(dirname "$destination_absolute")"
			ln -sf "$source_absolute" "$destination_absolute"
			echo "linked $destination_absolute -> $source_absolute"

		done <"$symlinks_file"
	fi
done

next_script="./set_shell_bootstrap_05.sh"

info "Running $next_script..."
"$next_script" "$BOOTSTRAP_OS" "$BOOTSTRAP_SHELL"
