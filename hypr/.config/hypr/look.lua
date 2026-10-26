-------------------
---- LOOK.LUA  ----
-------------------

-- Colors come from theme/palette (lines in the form name=#hex)
local function load_palette(path)
    local colors = {}
    for line in io.lines(path) do
        local name, hex = line:match("^%s*([%w_]+)%s*=%s*#(%x%x%x%x%x%x)")
        if name then colors[name] = hex end
    end
    return colors
end

local palette = load_palette(os.getenv("HOME") .. "/dotfiles/theme/palette")

-- rgba("tresnja", 0.4) -> "rgba(D9A7B066)"
local function rgba(name, alpha)
    return string.format("rgba(%s%02x)", palette[name], math.floor((alpha or 1) * 255 + 0.5))
end

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 8,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = { rgba("zrela_tresnja"), rgba("tresnja") }, angle = 45 },
            inactive_border = rgba("magla", 0.4),
        },
    },

    decoration = {
        rounding       = 16,
        rounding_power = 2,

        active_opacity   = 0.95,
        inactive_opacity = 0.88,

        shadow = {
            enabled      = true,
            range        = 20,
            render_power = 3,
            color        = rgba("kora", 0.6),
        },

        blur = {
            enabled  = true,
            size     = 8,
            passes   = 3,
            vibrancy = 0.15,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Slow, soft animations: only beziers that never overshoot, so nothing bounces
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("softOut",   { type = "bezier", points = { {0.16, 1},   {0.3, 1}  } })
hl.curve("softInOut", { type = "bezier", points = { {0.45, 0},   {0.55, 1} } })
hl.curve("linear",    { type = "bezier", points = { {0, 0},      {1, 1}    } })

hl.animation({ leaf = "global",     enabled = true, speed = 8,  bezier = "softOut" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "softOut" })
hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "softOut" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 7,  bezier = "softOut",   style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5,  bezier = "softInOut", style = "popin 90%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "softOut" })
hl.animation({ leaf = "layers",     enabled = true, speed = 6,  bezier = "softOut",   style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7,  bezier = "softInOut", style = "fade" })
