-->> utils/importer.lua
-->> 🧠 PhobisHub Importer
-->> Handles GitHub fetching, caching, and import execution

local DEV_MODE = true -->> true = prefer local files, false = use GitHub only

local function has(fn)
	return type(fn) == "function"
end

local FS = {
	read      = has(readfile) and readfile or nil,
	write     = has(writefile) and writefile or nil,
	mkdir     = has(makefolder) and makefolder or nil,
	exists    = has(isfile) and isfile or nil,
	isdir     = has(isfolder) and isfolder or nil,
	delfolder = has(delfolder) and delfolder or nil,
	list      = has(listfiles) and listfiles or nil,
	delfile   = has(delfile) and delfile or nil,
}

local function path_join(...)
	local parts = {...}
	for i = 1, #parts do
		parts[i] = tostring(parts[i]):gsub("[/\\]+$", ""):gsub("^[/\\]+", "")
	end
	return table.concat(parts, "/")
end

-->> Ensure subfolders exist for a given path
local function ensureFolderExists(path)
	if not FS.isdir or not FS.mkdir then return end
	local current = ""
	for part in string.gmatch(path, "[^/]+") do
		if not part:find("%.lua$") then
			current = (current == "" and part) or (current .. "/" .. part)
			if not FS.isdir(current) then
				pcall(FS.mkdir, current)
			end
		end
	end
end

-->> Recursive delete for cache clearing
local function deleteFolder(path)
	if not FS.isdir or not FS.list then return end
	if not FS.isdir(path) then return end

	for _, item in pairs(FS.list(path)) do
		if FS.isdir(item) then
			deleteFolder(item)
		elseif FS.exists(item) then
			pcall(FS.delfile, item)
		end
	end

	pcall(FS.delfolder, path)
end

--// Importer object
local Importer = {}
Importer.__index = Importer

function Importer.new(opts)
	assert(type(opts)      == "table", "opts table required")
	assert(type(opts.user) == "string", "opts.user required")
	assert(type(opts.repo) == "string", "opts.repo required")

	local self = setmetatable({}, Importer)
	self.user = opts.user
	self.repo = opts.repo
	self.branch = opts.branch or "main"
	self.root = (opts.root and opts.root:gsub("^/", ""):gsub("/$", "")) or ""
	self.cacheDir = opts.cache_dir or "ghcache"
	self.cache = {}

	-->> Create cache structure
	if FS.mkdir then
		local base = path_join(self.cacheDir, self.user, self.repo, self.branch)
		if not FS.isdir(self.cacheDir) then FS.mkdir(self.cacheDir) end
		ensureFolderExists(base)
	end

	-->> Open up a global import function
	function self.import(modulePath, forceRefresh)
		return self:_import(modulePath, forceRefresh)
	end

	-->> Provide a cache clear helper
	function self.clearCache()
		print("[Importer] 🧹 Clearing cache folder:", self.cacheDir)
		deleteFolder(self.cacheDir)
		ensureFolderExists(path_join(self.cacheDir, self.user, self.repo, self.branch))
	end

	return self
end

function Importer:_raw_url(modulePath)
	local base = ("https://raw.githubusercontent.com/%s/%s/%s"):format(self.user, self.repo, self.branch)
	local rel  = self.root ~= "" and path_join(self.root, modulePath .. ".lua") or (modulePath .. ".lua")
	return base .. "/" .. rel
end

function Importer:_disk_path(modulePath)
	local rel = self.root ~= "" and path_join(self.root, modulePath .. ".lua") or (modulePath .. ".lua")
	return path_join(self.cacheDir, self.user, self.repo, self.branch, rel)
end

function Importer:_load_module(source, chunkName)
	local loader = (loadstring or load)
	assert(loader, "[Importer] loadstring not available in environment")

	local chunk, err = loader(source, chunkName)
	if not chunk then error("[Importer] Syntax error in " .. chunkName .. ": " .. tostring(err)) end

	local ok, result = pcall(chunk)
	if not ok then error("[Importer] Runtime error in " .. chunkName .. ": " .. tostring(result)) end

	return result
end

function Importer:_import(modulePath, forceRefresh)
	assert(type(modulePath) == "string" and modulePath ~= "", "modulePath must be non-empty")

    local diskFile = self:_disk_path(modulePath)

    if forceRefresh then
        -->> drop memory
        self.cache[modulePath] = nil
        -->> drop disk
        if FS.exists and FS.exists(diskFile) and FS.delfile then
            pcall(FS.delfile, diskFile)
        end
    end

	-->> 1️⃣ Memory cache
	if self.cache[modulePath] then
		print(("[Importer] ⚡ %s (memory cache)"):format(modulePath))
		return self.cache[modulePath]
	end

	local source, sourceType = nil, "web"

	if DEV_MODE then
		local localPath = modulePath .. ".lua"
		if FS.exists and FS.exists(localPath) then
			print(("[DEV] ⚡ Using local file: %s"):format(localPath))
			local ok, content = pcall(FS.read, localPath)
			if ok and content and #content > 0 then
				source = content
				sourceType = "local"
			end
		end
	end

	-->> 2️⃣ Disk cache
	if FS.read and FS.exists and FS.exists(diskFile) then
		local ok, content = pcall(FS.read, diskFile)
		if ok and content and #content > 0 then
			source = content
			sourceType = "disk"
		end
	end

	-->> 3️⃣ Network fetch
	if not source then
		local url = self:_raw_url(modulePath)
		print("[Importer] 🌐 Fetching:", url)
		source = game:HttpGetAsync(url .. "?t=" .. os.time())
		if FS.write then
			ensureFolderExists(diskFile)
			pcall(FS.write, diskFile, source)
		end
	end

	-->> 4️⃣ Compile + execute
	local result = self:_load_module(source, ("@" .. modulePath))
	self.cache[modulePath] = result

	print(("[Importer] ✅ %s loaded (%s)"):format(modulePath, sourceType))
	return result
end

-->> Rebuild a specific file
-->> Example:

--[[
    
    __Importer:invalidate("modules/player/get_skips", true)

    OR
    
    import("modules/player/get_skips", true)

--]]

function Importer:invalidate(modulePath, deleteDisk)
    self.cache[modulePath] = nil
    if deleteDisk then
        local f = self:_disk_path(modulePath)
        if FS.exists and FS.exists(f) and FS.delfile then pcall(FS.delfile, f) end
    end
end

-->> Clears memory cache
function Importer:clear()
	for k in pairs(self.cache) do
		self.cache[k] = nil
	end
	print("[Importer] 🧠 Memory cache cleared.")
end

return {
	new = Importer.new
}
