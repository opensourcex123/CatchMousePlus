# CatchMousePlus

[简体中文](#简体中文) · [English](#english)

## 简体中文

CatchMousePlus 是一个 macOS 多屏工具，运行在 Hammerspoon 中。按一次快捷键，鼠标会跳到目标屏幕的中央，键盘焦点会切到该屏幕当前 Space 中最靠前的普通窗口。它不会模拟鼠标点击；如果目标屏幕没有可聚焦的窗口，仍然会移动鼠标，键盘焦点不会主动改变。

### 安装

1. 安装 Hammerspoon（也可以运行 `brew install --cask hammerspoon`），打开它，并在「系统设置 → 隐私与安全性 → 辅助功能」中授权。[Hammerspoon 官网](https://www.hammerspoon.org/)
2. 克隆本仓库，或在 GitHub 上选择 **Code → Download ZIP** 后解压。进入项目目录。如果是首次配置 Hammerspoon，运行下面的命令。`cp -n` 会保留已有的同名文件。

   ```sh
   mkdir -p ~/.hammerspoon
   cp -n init.lua catchmouseplus.lua ~/.hammerspoon/
   ```

   如果已有 `~/.hammerspoon/init.lua`，只复制 `catchmouseplus.lua`，然后在现有的 `init.lua` 中添加：

   ```lua
   require("catchmouseplus").start()
   ```

3. 在 Hammerspoon 菜单中选择 **Reload Config**。如果还在使用 CatchMouse 或其他热键工具，避免给两个工具绑定同一组快捷键。

### 快捷键

- `⌃⌥⌘1`：主显示器（macOS 系统设置中指定的主显示器）。
- `⌃⌥⌘2`、`⌃⌥⌘3`、`⌃⌥⌘4`：其余显示器，按系统显示器排列中的位置从左到右编号；左边缘对齐时，从上到下编号。
- 显示器插拔或重新排列后，下一次按键就会按新布局计算。按到不存在的编号时，只显示提示。

可以在 `~/.hammerspoon/init.lua` 中修改 `modifiers` 和 `keys`。`keys` 数组中的第 N 个键对应第 N 块屏幕。下面的配置为前两块屏幕绑定 `⌃⌥⌘F1` 和 `⌃⌥⌘F2`。

```lua
require("catchmouseplus").start({
    modifiers = { "ctrl", "alt", "cmd" },
    keys = { "F1", "F2" },
})
```

保存后，在 Hammerspoon 菜单中选择 **Reload Config**。

### 验证

自动测试使用模拟的 Hammerspoon API，不需要辅助功能权限。在项目目录运行 `lua test_catchmouseplus.lua`（Lua 5.4 或更新版本）。

实机验证时，在两块屏幕上各打开一个可输入的窗口，按快捷键跳到另一块屏幕，然后直接键入字符。确认输入进入目标窗口，并且鼠标停在目标屏幕中央。再切到一个没有普通窗口的 Space 重试，确认鼠标仍然会移动。需要分别使用两块屏幕的 Space 时，请在 macOS 的「桌面与程序坞」设置中打开「显示器具有单独的空间」。

### 开源协议

本项目采用 [MIT License](LICENSE)。

## English

CatchMousePlus is a Hammerspoon utility for switching between displays on macOS. Press a shortcut to move the pointer to the center of the target display and focus the frontmost regular window on that display in the current Space. It never simulates a click. If there is no eligible window, it moves the pointer without changing keyboard focus.

### Installation

1. Install [Hammerspoon](https://www.hammerspoon.org/) (or run `brew install --cask hammerspoon`). Open it and grant access under **System Settings → Privacy & Security → Accessibility**.
2. Clone this repository or choose **Code → Download ZIP** on GitHub and extract it. Open the project directory. If this is your first Hammerspoon setup, run the following commands. `cp -n` leaves existing files untouched.

   ```sh
   mkdir -p ~/.hammerspoon
   cp -n init.lua catchmouseplus.lua ~/.hammerspoon/
   ```

   If you already have a `~/.hammerspoon/init.lua`, copy only `catchmouseplus.lua` into `~/.hammerspoon/` and add this line to your existing `init.lua`:

   ```lua
   require("catchmouseplus").start()
   ```

3. Choose **Reload Config** from the Hammerspoon menu. If you also use CatchMouse or another hotkey utility, avoid assigning the same shortcuts in both tools.

### Keyboard shortcuts

- `⌃⌥⌘1`: The primary display, as configured in macOS System Settings.
- `⌃⌥⌘2`, `⌃⌥⌘3`, `⌃⌥⌘4`: The remaining displays, numbered from left to right in the macOS display arrangement. Displays with the same left edge are ordered from top to bottom.
- If you connect, disconnect, or rearrange a display, the next keypress uses the new layout. A shortcut for an unavailable display only shows an alert.

To customize the shortcuts, set `modifiers` and `keys` in `~/.hammerspoon/init.lua`. The Nth key targets display N. This example binds `⌃⌥⌘F1` and `⌃⌥⌘F2` to the first two displays:

```lua
require("catchmouseplus").start({
    modifiers = { "ctrl", "alt", "cmd" },
    keys = { "F1", "F2" },
})
```

Save the file and choose **Reload Config** from the Hammerspoon menu.

### Testing

The automated tests mock the Hammerspoon API and do not require Accessibility permissions. Run `lua test_catchmouseplus.lua` from the project directory with Lua 5.4 or later.

To test on a Mac, open a window that accepts text on each of two displays. Use a shortcut to switch displays, then type. Confirm that text goes into the target window and the pointer is centered on the target display. Repeat with a Space that has no regular windows and confirm that the pointer still moves. If you want each display to use its own Spaces, enable **Displays have separate Spaces** under **System Settings → Desktop & Dock**.

### License

CatchMousePlus is released under the [MIT License](LICENSE).
