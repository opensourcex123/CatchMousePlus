local function display(id, x, y, w, h)
    return {
        id = function() return id end,
        fullFrame = function() return { x = x, y = y, w = w, h = h } end,
    }
end

local main = display(11, 0, 0, 1440, 900)
local left = display(22, -1920, -180, 1920, 1080)
local below = display(33, -1920, 900, 1920, 1080)
local right = display(44, 1440, 0, 1920, 1080)
local screens = { right, below, left, main }
local windows, events, bindings = {}, {}, {}

hs = {
    screen = {
        primaryScreen = function() return main end,
        allScreens = function() return screens end,
    },
    mouse = {
        absolutePosition = function(point)
            events[#events + 1] = { "move", point.x, point.y }
        end,
    },
    window = { orderedWindows = function() return windows end },
    alert = { show = function() events[#events + 1] = { "alert" } end },
    hotkey = {
        bind = function(modifiers, key, pressed)
            bindings[key] = { modifiers = modifiers, pressed = pressed }
            return bindings[key]
        end,
    },
}

local function window(name, screen, standard)
    return {
        isStandard = function() return standard end,
        screen = function() return screen end,
        focus = function() events[#events + 1] = { "focus", name } end,
    }
end

local app = require("catchmouseplus")

local function expectEvents(...)
    local expected = { ... }
    assert(#events == #expected, "unexpected number of events")
    for i, event in ipairs(expected) do
        local actual = events[i]
        assert(#actual == #event, "unexpected event size at " .. i)
        for j, value in ipairs(event) do
            assert(actual[j] == value, string.format("event %d field %d: expected %s, got %s", i, j, value, actual[j]))
        end
    end
    events = {}
end

-- Main display first, then by horizontal and vertical position.
local ordered = app.screens()
assert(ordered[1].id == 11 and ordered[2].id == 22 and ordered[3].id == 33 and ordered[4].id == 44)

-- Skip other displays, nonstandard windows, and windows without a display.
windows = {
    window("other display", main, true),
    window("panel", left, false),
    window("disappeared", nil, true),
    window("front", left, true),
    window("behind", left, true),
}
assert(app.jump(2))
expectEvents({ "move", -960, 360 }, { "focus", "front" })

-- No eligible window: move only, leaving focus alone.
assert(app.jump(3))
expectEvents({ "move", -960, 1440 })

-- Disconnected display: do not move or focus; re-evaluate on the next key press.
screens = { main }
assert(not app.jump(2))
expectEvents({ "alert" })

-- Entry point registers each shortcut against its own index.
dofile("init.lua")
assert(table.concat(bindings["1"].modifiers, "+") == "ctrl+alt+cmd")
screens = { left, main }
bindings["1"].pressed()
expectEvents({ "move", 720, 450 }, { "focus", "other display" })
bindings["2"].pressed()
expectEvents({ "move", -960, 360 }, { "focus", "front" })
screens = { right, main }
bindings["2"].pressed()
expectEvents({ "move", 2400, 540 })

-- A custom shortcut invokes the same action.
local custom = app.start({ modifiers = { "shift", "cmd" }, keys = { "F12" } })
assert(#custom == 1 and table.concat(bindings.F12.modifiers, "+") == "shift+cmd")
bindings.F12.pressed()
expectEvents({ "move", 720, 450 }, { "focus", "other display" })

print("CatchMousePlus: all tests passed")
