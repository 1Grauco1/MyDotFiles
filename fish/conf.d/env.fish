# Clean PATH handling
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# Less pager
set -gx LESS "-R"

# Better man pages
set -gx MANPAGER "less -R"
