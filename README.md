# Phlompfporter
![GitHub Release](https://img.shields.io/github/v/release/PhlompfDev/PhobisHub)
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/PhlompfDev/PhobisHub/total)

| ![Real Footage Of Me Making This Repository](https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExNXpsOWQwdTl1bGZpemk2M2RwNjBwOHdobjFnMHAyMWY0cmJqbDQ1MCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/12W5Sg2koWYnwA/giphy.gif)	| 
|:--:												| 

# PhobisHub

```lua
-->> 🧠 PhobisHub Bootstrapper

local Importer = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/PhlompfDev/PhobisHub/main/utils/importer.lua"))().new{
	user = "PhlompfDev",
	repo = "PhobisHub",
	branch = "dev",
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
