function load_theme(avgcolor, comcolor)

    local theme = require("default/theme")

    if avgcolor then
        theme.bg_normal     = avgcolor
        theme.bg_focus      = theme.bg_normal
        theme.bg_urgent     = "#ff0000" -- TODO should be opposite of bg_normal
        theme.bg_minimize   = theme.bg_normal
        theme.bg_systray    = theme.bg_normal
    end

    if comcolor then
        theme.fg_normal     = comcolor
        theme.fg_focus      = comcolor
        theme.fg_urgent     = "#ffffff"
        theme.fg_minimize   = comcolor
    end

    return theme

end
