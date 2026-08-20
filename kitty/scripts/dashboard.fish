#!/usr/bin/env fish

# Launch kitty windows for dashboard layout
# Top-left: system monitor
kitty --title "btop" btop &

# Top-right: system info
kitty --title "system" htop &

# Bottom-right: matrix effect
kitty --title "pipes" pipes.sh -t 0 &