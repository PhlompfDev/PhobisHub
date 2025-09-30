-->> init.lua
-->> 🧠 Handles version checking and cache refresh

local user = "PhlompfDev"
local repo = "PhobisHub"
local cacheDir = "phobishub_cache"
local branch = "main"

local HttpService = game:GetService("HttpService")

local FS = {
	read = readfile,
	write = writefile,
	isdir = isfolder,
	delfolder = delfolder,
    delfile = delfile,
}

local versionFile = "__phobishub_version.txt"
local rootToWipe = cacheDir .. '/' .. user .. '/' .. repo .. '/' .. branch

local function deleteTree(path)
    if not (isfolder and isfile and listfiles and delfile and delfolder) then return end
    if not isfolder(path) then return end
    for _, p in pairs(listfiles(path)) do
        if isfolder(p) then
            deleteTree(p)
        elseif isfile(p) then
            pcall(FS.delfile, p)
        end
    end
    pcall(FS.delfolder, path)
end

local function clearCache()
    print("[Init] 🧹 Clearing cache at:", rootToWipe)
    deleteTree(rootToWipe)
    -->> also clear in-memory modules currently held by the importer
    if getgenv and getgenv().__Importer then
        getgenv().__Importer:clear()        --<< wipe memory cache table
    end
end

-->> Fetch GitHub release info
local ok, data = pcall(function()
	return HttpService:JSONDecode(game:HttpGetAsync("https://api.github.com/repos/" .. user .. "/" .. repo .. "/releases"))
end)
local releaseInfo = ok and data and data[1]

if FS.read and FS.write and releaseInfo then
	local ran, localVersion = pcall(FS.read, versionFile)
	local latest = releaseInfo.tag_name

	if not ran or localVersion ~= latest then
		print(("[Init] 🔄 Version mismatch (%s → %s), rebuilding cache..."):format(tostring(localVersion), latest))
		clearCache()
		FS.write(versionFile, latest)
	else
		print("[Init] ✅ Version up-to-date:", latest)
	end
else
	warn("[Init] ⚠️ Could not retrieve release info from GitHub")
end

return true
