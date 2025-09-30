if not game:IsLoaded() then
	game.Loaded:Wait()
end

print('[Auto Execute] ✅ Game fully loaded! Running Phobis Hub Bootstrapper')

-->> 🧠 PhobisHub Bootstrapper

local cacheDir = 'phobishub_cache'
local importerPath = cacheDir .. '/importer.lua'
local importerURL = 'https://raw.githubusercontent.com/PhlompfDev/PhobisHub/main/utils/importer.lua'

if makefolder and not isfolder(cacheDir) then
	makefolder(cacheDir)
end

local src
if isfile and isfile(importerPath) then
	local ok, content = pcall(readfile, importerPath)
	if ok and content and #content > 0 then
		print('[Bootstrap] ⚡ Using cached importer')
		src = content
	end
end

if not src then
	print('[Bootstrap] 🌐 Downloading importer')
	src = game:HttpGetAsync(importerURL .. '?t=' .. os.time())
	if writefile then
		pcall(writefile, importerPath, src)
	end
end

local Importer = loadstring(src, "@importer")().new({
	user = 'PhlompfDev',
	repo = 'PhobisHub',
	branch = 'dev',
	root = '',
	cache_dir = 'phobishub_cache',
})

-->> Expose import globally
getgenv().import = Importer.import
-->> give init a handle
getgenv().__Importer = Importer

-->> Run init (version check + rebuild)
import('init')
