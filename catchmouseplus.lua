local CatchMousePlus = {}

-- Screen 1 is the display with the macOS primary menu bar, not the focused display.
function CatchMousePlus.screens()
    local primary = hs.screen.primaryScreen()
    local primaryID = primary and primary:id()
    local displays = {}
    for _, screen in ipairs(hs.screen.allScreens()) do
        local id = screen:id()
        displays[#displays + 1] = { id = id, frame = screen:fullFrame() }
    end
    table.sort(displays, function(a, b)
        if a.id == primaryID then return b.id ~= primaryID end
        if b.id == primaryID then return false end
        if a.frame.x ~= b.frame.x then return a.frame.x < b.frame.x end
        if a.frame.y ~= b.frame.y then return a.frame.y < b.frame.y end
        return a.id < b.id
    end)
    return displays
end

function CatchMousePlus.jump(index)
    -- Resolve on every key press so hot-plugging or rearranging screens needs no reload.
    local target = CatchMousePlus.screens()[index]
    if not target then
        hs.alert.show(string.format("CatchMousePlus：未连接第 %d 块屏幕", index))
        return false
    end

    local frame = target.frame
    hs.mouse.absolutePosition({ x = frame.x + frame.w / 2, y = frame.y + frame.h / 2 })

    -- The list is front-to-back and limited to visible windows in the active Spaces.
    -- Do not click the screen: the center could be on a button or a different window.
    for _, window in ipairs(hs.window.orderedWindows()) do
        if window:isStandard() then
            local screen = window:screen()
            if screen and screen:id() == target.id then
                window:focus()
                break
            end
        end
    end
    return true
end

function CatchMousePlus.start(options)
    options = options or {}
    local modifiers = options.modifiers or { "ctrl", "alt", "cmd" }
    local keys = options.keys or { "1", "2", "3", "4" }
    local hotkeys = {}
    for index, key in ipairs(keys) do
        local hotkey = hs.hotkey.bind(modifiers, key, function()
            CatchMousePlus.jump(index)
        end)
        if hotkey then
            hotkeys[#hotkeys + 1] = hotkey
        else
            print("CatchMousePlus: 无法绑定快捷键 " .. table.concat(modifiers, "+") .. "+" .. key)
        end
    end
    return hotkeys
end

return CatchMousePlus
