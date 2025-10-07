# PhobisHub

```lua
-->> 🧠 PhobisHub Bootstrapper

local Importer = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/PhlompfDev/PhobisHub/main/utils/importer.lua"))().new{
	user = "PhlompfDev",
	repo = "PhobisHub",
	branch = "main",
	root = "",
	cache_dir = "phobishub_cache"
}

getgenv().import = Importer.import
getgenv().__Importer = Importer

-->> version check + rebuild
import("init")
```
# Example
```lua
local getAvailableSkips = import("modules/player/get_skips")
local player = game.Players.LocalPlayer
print("[Main] Available skips:", getAvailableSkips(player))
```
