local mainMod = "SUPER"

hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/quickshell/launch.sh reload"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("~/.config/quickshell/launch.sh media"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/quickshell/launch.sh wallpaper"))
