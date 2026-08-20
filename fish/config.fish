if status is-interactive
    set fish_greeting
end

# Environment
set -gx EDITOR nvim
set -gx TERMINAL kitty

# Enable Starship prompt
starship init fish | source

if test -z "$DISPLAY" -a (tty) = "/dev/tty1"
    exec start-hyprland >/dev/null 2>&1
end

set -Ux GTK_THEME dynamic-materia-dark
set -Ux QT_QPA_PLATFORMTHEME qt5ct
set -Ux QT_STYLE_OVERRIDE kvantum-dark
set -Ux GTK_ICON_THEME OneUI-dark

set -U fish_user_paths $HOME/.local/bin $fish_user_paths
fish_add_path ~/.local/bin

# Abbreviations
abbr -a ll "ls -lah"
abbr -a la "ls -a"
abbr -a gs "git status"
abbr -a gc "git commit"
abbr -a v "nvim"
abbr -a y "yazi"
abbr -a wm "wiremix"

# Run fastfetch only once when terminal opens
#if status is-interactive
#    if not set -q __fastfetch_done
#        set -g __fastfetch_done 1
#        fastfetch
#    end
