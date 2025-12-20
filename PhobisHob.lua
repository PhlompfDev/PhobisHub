--[[
╔════════════════════════════╗
║        Phobis Hub          ║
║                            ║
║  A simple hub that hacks   ║
║       Miners Haven         ║
║                            ║
║ Credits:                   ║
║  - Phobis                  ║
║  - Bingledong              ║
╚════════════════════════════╝
--]]

local plr = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-->> Active tycoon becomes nil when you step off your base, as a byproduct dropped parts also becomes nil.
-->> So we just use PlayerTycoon which was always a thing and I just never knew it smile
local factoryName = plr.PlayerTycoon.Value
local orePath = workspace.DroppedParts[tostring(factoryName)]

local furnace = nil
local boxes = workspace.Boxes
local ItemIndex = loadstring(game:HttpGet("https://pastebin.com/raw/6gke3kt4"))()

local NegativeEffectCache = {}
local IsResetterCache = {}

local function getNegativeEffectCached(name)
    if NegativeEffectCache[name] ~= nil then
        return NegativeEffectCache[name]
    end
    local ok, result = pcall(function()
        return ItemIndex.GetNegativeEffect(name)
    end)
    NegativeEffectCache[name] = ok and result or nil
    return NegativeEffectCache[name]
end

local function isResetterCached(name)
    if IsResetterCache[name] ~= nil then
        return IsResetterCache[name]
    end
    local ok, result = pcall(function()
        return ItemIndex.IsResetter(name)
    end)
    IsResetterCache[name] = ok and result or false
    return IsResetterCache[name]
end


local upgraderBeams = {}


-- //=====================[ Auto Crate ]=====================//

function touchBoxes()
    local character = plr.Character
    if not character then
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    local startCFrame = root.CFrame
    local teleported = false

    for _, v in pairs(boxes:GetChildren()) do
        if v:FindFirstChild("TouchInterest") or v:FindFirstChild("Crate") then
            local touch = v:FindFirstChild("TouchInterest")
            local crate = v:FindFirstChild("Crate")
            local hitbox = crate or (touch and touch.Parent)

            if hitbox and hitbox:IsA("BasePart") then
                root.CFrame = hitbox.CFrame
                teleported = true
                task.wait(0.05)
                firetouchinterest(hitbox, root, 0)
                firetouchinterest(hitbox, root, 1)
                task.wait(0.05)
            end
        end
    end

    if teleported then
        root.CFrame = startCFrame
        task.wait(1/30)
        root.Velocity = Vector3.zero
    end
end

function openBox(boxType)
    game:GetService("ReplicatedStorage").MysteryBox:InvokeServer(unpack({boxType}))
end

-- //=======================================================//







-- //=====================[ Helper Functions ]=====================//

function findFurnaces(specifiedFurnace)
    -- print("[Furnace] Scanning for furnaces...")
    local furnaceSpecified = 895 --<< Temporary, will make this configurable later
    for i,v in pairs(factoryName:GetChildren()) do
        -->> ItemType 2 is furnace, refer to readme.md
        if v:FindFirstChild("ItemType") and v:FindFirstChild("ItemId") then
            if v.Model:FindFirstChild("Lava") and v.ItemId.Value == 895 then
                -- print("[Furnace] Found lava furnace.")
                furnace = v.Model.Lava
            end
        end
    end
end

-->> Sanity Check for Upgraders before Ore Boosting
function findUpgraders()
    table.clear(upgraderBeams)

    for i,v in pairs(factoryName:GetChildren()) do
        -->> ItemType 3 is upgrader, refer to readme.md
        if v:FindFirstChild("ItemType") then
            local mobel = v.Model

            -->> Checks for the various names of upgrader beams
            local upgraderPart = mobel:FindFirstChild("Upgrade") or mobel:FindFirstChild("Scan") or mobel:FindFirstChild("Error", true)
            if upgraderPart then

                if upgraderPart:IsA("Sound") then
                    upgraderPart = upgraderPart.Parent
                end
                table.insert(upgraderBeams, upgraderPart)
            end
        end
    end
end

local function getOreCash(ore)
    if not ore then return nil end
    local c = ore:FindFirstChild("Cash")
    if c and typeof(c.Value) == "number" then
        return c.Value
    end
    return nil
end

-->> Loop touches as fast as possible until ore value >= target, or stalls

local function loopTouchUntilValue(ore, beam, targetValue)
    if not (ore and beam and beam.Parent) then return end

    local wasAnchored = ore.Anchored
    ore.Anchored = true
    ore.AssemblyLinearVelocity = Vector3.zero
    ore.AssemblyAngularVelocity = Vector3.zero

    ore.CFrame = beam.CFrame
    task.wait(1/120)

    local function getOreCash(ore)
        if not ore then return nil end
        local c = ore:FindFirstChild("Cash")
        if c and typeof(c.Value) == "number" then
            return c.Value
        end
        return nil
    end

    -->> Loop parameters
    local lastVal = getOreCash(ore) or 0
    local sameCount, totalPulses = 0, 0
    local MAX_PULSES_HARD_CAP = 12000
    local STALL_WINDOW = 30
    local TOL = 5e-7  -->> 0.00005% tolerance for float wiggle
    local MIN_DWELL = 0.25

    local MIN_PULSES_BEFORE_STALL = 2000
    local MIN_TIME_BEFORE_STALL   = 70.25

    local function noGrowth(oldV, newV)
        if not oldV or not newV then return true end

        -->> Require at least ~0.0001% relative growth OR 1 absolute unit
        local absEps = 1
        local relEps = math.max(absEps, math.abs(oldV) * 1e-6)  -->> 0.0001% = 1e-6

        return (newV - oldV) <= relEps
    end

    local tStart = os.clock()
    do
        local t0 = os.clock()
        repeat
            ore.CFrame = beam.CFrame
            task.wait(1/60)
        until (os.clock() - t0) >= MIN_DWELL
    end

    while true do
        if not (beam and beam.Parent) then break end

        local v = lastVal
        if targetValue and v and v >= targetValue * (1 - TOL) then
            break
        end

        -->> 1) SNAP TO LOOP BEAM FIRST
        ore.CFrame = beam.CFrame
        task.wait(1/120)

        -->> 2) PULSE ON THE LOOP BEAM
        pcall(firetouchinterest, ore, beam, 0)
        pcall(firetouchinterest, ore, beam, 1)
        totalPulses += 1

        -->> 3) SERVER TICK
        task.wait(1/60)

        -->> 4) READ VALUE
        local newVal = getOreCash(ore) or v

        -->> 5) DYNAMIC STALL: blocked until warm-up met
        local allowStall = (totalPulses >= MIN_PULSES_BEFORE_STALL) and ((os.clock() - tStart) >= MIN_TIME_BEFORE_STALL)
        if allowStall and noGrowth(v, newVal) then
            sameCount += 1
        else
            sameCount = 0
            -->> if still growing, extend patience up to 60
            if newVal and v and newVal > v then
                STALL_WINDOW = math.min(STALL_WINDOW + 1, 60)
            end
        end
        lastVal = newVal

        if allowStall and sameCount >= STALL_WINDOW then break end
        if totalPulses >= MAX_PULSES_HARD_CAP then break end

        -->> 6) ATLANTIC MONOLITH EXTINGUISHER (if present)
        if factoryName:FindFirstChild("Atlantic Monolith") then
            local atl = factoryName["Atlantic Monolith"].Model and factoryName["Atlantic Monolith"].Model:FindFirstChild("Upgrade")
            if atl and atl:IsA("BasePart") then
                ore.CFrame = atl.CFrame
                pcall(firetouchinterest, ore, atl, 0)
                pcall(firetouchinterest, ore, atl, 1)
                task.wait(1/120)
            end
        end
    end

    ore.Anchored = wasAnchored
end



local activeLoops = {}

local function startLoop(key, fn, delay)
    if activeLoops[key] then return end
    activeLoops[key] = true
    task.spawn(function()
        while activeLoops[key] do
            local ok, err = pcall(fn)
            if not ok then warn(("[%s] %s"):format(key, err)) end
            task.wait(delay or 0)
        end
    end)
end

local function stopLoop(key)
    activeLoops[key] = nil
end

-- //=======================================================//







-- //=====================[ Ore Booster ]=====================//
local getAvailableSkips = import("modules/player/get_skips")

local allowedSkips = nil
local skipToggleValue = nil

local function rebirth()
    local skipOn = skipToggleValue
    local skips = getAvailableSkips(plr)
    
    if skipOn then
        if skips and skips >= allowedSkips then
            game:GetService("ReplicatedStorage").Rebirth:InvokeServer(unpack({26}))
        end
        return
    else
        game:GetService("ReplicatedStorage").Rebirth:InvokeServer(unpack({26}))
    end
end

-->> Options
local LOOP_MODE_ENABLED = false
local CACHED_LIMIT_BEAM = nil
local CACHED_RESETTERS = {}

-- =================== Priority + Limit Handling (merged) ===================
-- Editable priority config:
--  - order: lower number = earlier in the chain
--  - mustBeFirst: if true, force this upgrader to the very front, but not before loop upgraders
--  - maxValue: when Loop Mode is ON, the max value of the upgrader.

local PRIORITY = {
    ["Garden of Gaia"]       = { order = 1, mustBeFirst = true   },
    ["Astral Predictor"]     = { order = 1, mustBeFirst = true   },
    ["Astral Setter"]        = { order = 1, mustBeFirst = true   },
    ["Atlantic Monolith"]    = { order = 2, mustBeFirst = true   },
    ["Turtle Dignifier"]     = { order = 3, mustBeFirst = true   },
    ["Helium Blaster"]       = { order = 4, mustBeFirst = true   },
    ["Pizza Parlor"]         = { order = 4, mustBeFirst = true   },
    ["Hades Palace"]         = { order = 9997                    },
    ["Brimstone Spires"]     = { order = 9998                    },
    ["Vulcan's Destiny"]     = { order = 9998                    },
    ["Delta Phantom"]        = { order = 9999                    },
    ["Freon-Blast Upgrader"] = { order = 100, maxValue = 1.2e+11 },
    ["Way-Up-High Upgrader"] = { order = 120, maxValue = 1e+9    },
    ["Serpentine Upgrader"]  = { order = 120, maxValue = 10e+12  },
    ["Catalyzed Star"]       = { order = 99, maxValue = 1e+60    },
--> ["Some Upgrader"]        = { order = 50, maxValue = 200, mustBeFirst = false },
}

local DEFAULT_LOOP_TARGET_VALUE = nil    -- nil = no ceiling known. Still loops with stall detection though
local ACTIVE_LOOP_TARGET_VALUE = DEFAULT_LOOP_TARGET_VALUE

-->> Track the previously selected loop beam so we can reposition ores when a new loop is chosen
local PREV_LIMIT_BEAM = nil

--[[
    Rescan and sort all upgraders according to the PRIORITY table and loop/limit handling.

    The function performs the following steps:
      1) Enumerate all placed items on the factory, looking for upgraders.  An upgrader
         is identified by the presence of an "ItemType" value and a child part named
         "Upgrade", "Scan", or "Error" (with an optional parent redirect if the part
         happens to be a Sound).
      2) For each upgrader found we determine its display name and query ItemIndex to
         figure out whether it has a negative effect of "limit" (making it a loop
         upgrader) and whether it's a resetter.  We also pull any overrides from the
         PRIORITY table.
      3) We partition upgraders into three buckets: loop upgraders, mustBeFirst
         upgraders, and all other upgraders.  Loop upgraders always come first, sorted
         by their order value (ascending).  mustBeFirst upgraders come next, also
         sorted by order.  Remaining upgraders are placed last, sorted by order.
      4) The global upgraderBeams list is rebuilt in this sorted order.  CACHED_RESETTERS
         is also rebuilt based on isResetterCached.  The active loop upgrader
         (CACHED_LIMIT_BEAM) and ACTIVE_LOOP_TARGET_VALUE are updated.  If the active loop
         upgrader changes from the previous selection, all currently dropped ores are
         repositioned onto the new loop upgrader so they begin looping on the new unit.

    Because this function touches physics objects (the ores) when switching loop
    upgraders, it should not be called too frequently.  It is triggered when
    upgraders are added or removed via ChildAdded/ChildRemoved events, when the
    user toggles Loop Mode on/off, or when Ore Booster is first started.
]]

function rescanAndSortUpgraders()
    if not factoryName then return end

    -->> Temp table to hold raw upgrader info
    local beamsData = {}
    local debugLoops, debugResets, debugTotal = 0, 0, 0

    for _, model in ipairs(factoryName:GetChildren()) do
        if model:FindFirstChild("ItemType") then
            local mobel = model.Model

            --> Functional part under a child called "Upgrade", "Scan", "Upgrade2", "Upgrader", or "Error".

            local upgraderPart = mobel:FindFirstChild("Upgrade") or mobel:FindFirstChild("Upgrade2") or mobel:FindFirstChild("Upgrader") or mobel:FindFirstChild("Scan") or mobel:FindFirstChild("Error", true)
            if upgraderPart then
                if upgraderPart:IsA("Sound") then
                    -- print("[Rescan] Redirecting from Sound to parent part.")
                    upgraderPart = upgraderPart.Parent
                end

                local name = (upgraderPart.Parent and upgraderPart.Parent.Parent and upgraderPart.Parent.Parent.Name) or upgraderPart.Name
                
                -->> Pull priority overrides
                local override = PRIORITY[name] or {}
                local order = override.order or 1000 -->> default high order if not specified
                local mustBeFirst = override.mustBeFirst == true
                local maxValue = override.maxValue                

                -->> Is it a loop upgrader
                local isLoop = false
                local okNeg, negEff = pcall(function()
                    return getNegativeEffectCached(name)
                end)

                if okNeg and negEff == "limit" then
                    isLoop = true
                end

                if not isLoop and maxValue ~= nil then
                    isLoop = true
                end

                -->> Is it a resetter
                local isResetter = false
                local res = isResetterCached(name)
                if res then
                    isResetter = true
                end

                table.insert(beamsData, {
                    beam = upgraderPart,
                    name = name,
                    isLoop = isLoop,
                    isReset = isResetter,
                    order = order,
                    mustBeFirst = mustBeFirst,
                    maxValue = maxValue,
                })

                debugTotal = debugTotal + 1
                if isLoop then debugLoops = debugLoops + 1 end
                if isResetter then debugResets = debugResets + 1 end
                -- -- print(debugResets)
                -- print(string.format("[Rescan] Found upgrader: %s | Loop=%s | Resetter=%s | Order=%d", name, tostring(isLoop), tostring(isResetter), order))
            end
        end
    end

    -->> Partition
    local loopsList = {}
    local mustList = {}
    local otherList = {}

    for _, data in ipairs(beamsData) do
        if data.isLoop then
            table.insert(loopsList, data)
        elseif data.mustBeFirst then
            table.insert(mustList, data)
        else
            table.insert(otherList, data)
        end
    end

    -->> Some AI gobbly gook to sort by order
    local function sortByOrder(a, b)
        return a.order < b.order
    end

    table.sort(loopsList, sortByOrder)
    table.sort(mustList, sortByOrder)
    table.sort(otherList, sortByOrder)

    -->> Rebuild global upgraderBeams based on sorted order, BUT skip resetters here.
    -->> Resetter touches are handled explicitly elsewhere.

    table.clear(upgraderBeams)
    local function pushNonReset(list)
        for _, data in ipairs(list) do
            if not data.isReset then
                table.insert(upgraderBeams, data.beam)
            end
        end
    end

    pushNonReset(loopsList)
    pushNonReset(mustList)
    pushNonReset(otherList)

    -->> Rebuild CACHED_RESETTERS
    table.clear(CACHED_RESETTERS)
    for _, data in ipairs(loopsList) do
        if data.isReset then
            table.insert(CACHED_RESETTERS, data.beam)
        end
    end
    for _, data in ipairs(mustList) do
        if data.isReset then
            table.insert(CACHED_RESETTERS, data.beam)
        end
    end
    for _, data in ipairs(otherList) do
        if data.isReset then
            table.insert(CACHED_RESETTERS, data.beam)
        end
    end
    
    -->> Determine active loop upgrader and update ACTIVE_LOOP_TARGET_VALUE
    local newLimitBeam = nil
    local newTargetValue = nil

    if #loopsList > 0 then
        newLimitBeam = loopsList[1].beam
        newTargetValue = loopsList[1].maxValue
    end

    local oldLimit = CACHED_LIMIT_BEAM
    CACHED_LIMIT_BEAM = newLimitBeam

    if newTargetValue ~= nil then
        -- print(ACTIVE_LOOP_TARGET_VALUE)
        ACTIVE_LOOP_TARGET_VALUE = newTargetValue
    else
        -- print("newTargetValue is nil" .. ACTIVE_LOOP_TARGET_VALUE)
        ACTIVE_LOOP_TARGET_VALUE = DEFAULT_LOOP_TARGET_VALUE -- may be nil
    end

    -->> Reposition ores if the active loop upgrader has changed
    if LOOP_MODE_ENABLED and oldLimit ~= nil and CACHED_LIMIT_BEAM ~= nil and oldLimit ~= CACHED_LIMIT_BEAM then
        PREV_LIMIT_BEAM = oldLimit

        -->> Only reposition ores if the new limit beam is still valid
        if CACHED_LIMIT_BEAM.Parent then
            for _, ore in ipairs(orePath:GetChildren()) do
                if ore:IsA("BasePart") then
                    ore.AssemblyLinearVelocity = Vector3.zero
                    ore.AssemblyAngularVelocity = Vector3.zero
                    ore.CFrame = CACHED_LIMIT_BEAM.CFrame
                end
            end
        end
    end

    -->> Debug summary of the rescan
    -- print(string.format("[Rescan] Total upgraders: %d | Loops: %d | Resetters: %d", #beamsData, #loopsList, #CACHED_RESETTERS))

    if CACHED_LIMIT_BEAM then
        -- print("[Rescan] Active loop upgrader:", CACHED_LIMIT_BEAM:GetFullName())
    else
        -- print("[Rescan] No loop upgrader selected.")
    end
    if #CACHED_RESETTERS == 0 then
        -- print("[Rescan] No resetters detected.")
    else
        for idx, rb in ipairs(CACHED_RESETTERS) do
            -- print(string.format("[Rescan] Resetter %d: %s", idx, rb:GetFullName()))
        end
    end
end

local rescanScheduled = false

--[[
    scheduleRescan(delay: number?)

    Defers a call to rescanAndSortUpgraders by the given delay (in seconds) but
    coalesces concurrent requests.  If a rescan is already pending or in
    progress, additional calls to scheduleRescan are ignored until the current
    rescan completes.  This helper should be used whenever you need to refresh
    the upgrader list instead of calling rescanAndSortUpgraders directly.
]]

local function scheduleRescan(delay)
    local waitTime = delay or 0
    -->> Only schedule if nothing is pending
    if not rescanScheduled then
        rescanScheduled = true
        task.spawn(function()
            -->> Allow other events to complete before rescanning
            if waitTime > 0 then
                task.wait(waitTime)
            end
            -->> Perform the actual rescan
            rescanAndSortUpgraders()
            rescanScheduled = false
        end)
    end
end

local slipStreamIDs = {
    ["Pulsar Octagnium Mine"] = 344,
    ["The Great Parasite"] = 345,
    ["Incendium Mine"] = 346,
    ["Utopian Refiner"] = 347,
    ["Dystopian Refiner"] = 348,
    ["Nature's Enchantment"] = 371,
    ["Burst Refiner"] = 372,
    ["Ore Supernova"] = 370,
    ["The Grand Prism"] = 419,
    ["Oblivion Weaver"] = 352,
    ["Neutropian Refiner"] = 849,
    ["Suitopian Refiner"] = 848,
    ["Behemoth Blossom"] = 847,
    ["Orbital Cataclysm"] = 850,
    ["Sinister Sepulcher"] = 1751,
}

-->> Search the player's inventory for an item by name. Returns the first matching entry (or false).
local function searchInventory(item)
    -- Compact: resolve name->id, fetch inventory, and return true only if the
    -- found entry reports a numeric Quantity > 0. Missing Quantity is treated as 0.

    local targetID = slipStreamIDs[item]
    if type(item) == "number" and not targetID then targetID = item end
    if not targetID then return false end

    -- normalize forms for reliable comparison
    local targetNum = tonumber(targetID)
    local targetStr = tostring(targetID)

    local ok, inv = pcall(function() return ReplicatedStorage.FetchInventory:InvokeServer() end)
    if not ok or type(inv) ~= "table" then return false end

    -- 1) map-by-id quick check - consider both numeric and string keys
    local entry = inv[targetNum] or inv[targetStr]
    if entry and type(entry) == "table" then
        return (type(entry.Quantity) == "number" and entry.Quantity > 0)
    end

    -- helper to compare ids robustly
    local function idMatches(id)
        if id == nil then return false end
        if type(id) == "number" and targetNum and id == targetNum then return true end
        local idNum = tonumber(id)
        if idNum and targetNum and idNum == targetNum then return true end
        return tostring(id) == targetStr
    end

    -- 2) scan entries for Id or numeric-first lists
    for _, v in pairs(inv) do
        if type(v) == "table" then
            local id = v.Id or v.ID or v.id or v.ItemId or v.ItemID or v[1]
            if idMatches(id) then
                return (type(v.Quantity) == "number" and v.Quantity > 0)
            end
        elseif type(v) == "number" and idMatches(v) then
            return false -- flat list: present but no Quantity field => treat as 0
        end
    end

    return false
end

-- [[ Dynamic factory binding and event handling ]]

-- The player's active tycoon (factory) can change after rebirths or when
-- stepping off the base.  To ensure upgraders and resetters are always
-- detected, we rebind our item listeners and caches whenever the active
-- factory changes.  This section introduces a bindFactory function that
-- disconnects old ChildAdded/ChildRemoved connections, updates global
-- references, refreshes the furnace, and schedules a rescan.  It also
-- connects to the PlayerTycoon.Value changed signal so we can rebind
-- automatically on rebirth.

-->> Connections to ChildAdded and ChildRemoved events on the current factory.
local factoryAddedConn
local factoryRemovedConn

-->> Rebind to the specified factory.  Passing nil will simply clear existing
-->> connections.  A rescan is scheduled after rebinding.
local function bindFactory(factory)
    -->> Update factoryName and orePath for the new tycoon
    factoryName = factory
    orePath = workspace.DroppedParts[tostring(factoryName)]

    -->> Refresh furnace for the new base
    furnace = nil
    if factoryName then
        findFurnaces()
    end

    -->> Disconnect existing listeners
    if factoryAddedConn then
        factoryAddedConn:Disconnect()
        factoryAddedConn = nil
    end

    if factoryRemovedConn then
        factoryRemovedConn:Disconnect()
        factoryRemovedConn = nil
    end

    -->> Connect new listeners on the new factory
    if factoryName then
        factoryAddedConn = factoryName.ChildAdded:Connect(function(child)
            if child:FindFirstChild("ItemType") then
                -->> Defer a little to allow initialisation
                scheduleRescan(0.2)
                -->> Schedule a second rescan a bit later to catch items that
                -->> weren't fully initialized when the first scan ran.
                -->> Helps ensure resetters are consistently detected.
                task.delay(1, function()
                    scheduleRescan(0)
                end)
            end
        end)

        factoryRemovedConn = factoryName.ChildRemoved:Connect(function(child)
            if child:FindFirstChild("ItemType") then
                scheduleRescan(0.05)
                -->> Also trigger a follow-up rescan after a short delay to
                -->> ensure caches are rebuilt correctly once removal is
                -->> completely processed.
                task.delay(1, function()
                    scheduleRescan(0)
                end)
            end
        end)
    end
    -->> Rebuild caches for the new factory
    scheduleRescan(0)
end

-->> Single-pass detector; only called when Loop Mode is toggled ON
local function findLimitBeamOnce()
    scheduleRescan(0)
end

-->> Called once when Ore Booster is toggled ON (not per ore)
local function findResettersOnce()
    -->> Trigger a rescan to rebuild CACHED_RESETTERS. Use scheduleRescan to avoid overlapping rescans.

    local oldCount = #CACHED_RESETTERS
    scheduleRescan(0)

    task.spawn(function()
        task.wait(0.1)
        -- print(("[Resetter Scan] Found %d resetter(s)."):format(#CACHED_RESETTERS))
    end)
end

local function touchOnce(ore, beam)
    if not (ore and beam and beam.Parent) then return end

    ore.AssemblyLinearVelocity = Vector3.zero
    ore.AssemblyAngularVelocity = Vector3.zero
    ore.CFrame = beam.CFrame

    task.wait(1/30)
    if beam and beam.Parent then
        -->> Double pulse improves reliability on finicky hitboxes
        pcall(firetouchinterest, ore, beam, 0)
        pcall(firetouchinterest, ore, beam, 1)
        task.wait(1/120)
        pcall(firetouchinterest, ore, beam, 0)
        pcall(firetouchinterest, ore, beam, 1)
    end
end

-->> Loop touches on a single upgrader
local function loopTouch(ore, beam, times)
    -->> Guard against nil or destroyed beams. It's possible for an upgrader to be removed while ores are looping on it
    if not (ore and beam and beam.Parent) then return end

    ore.AssemblyLinearVelocity = Vector3.zero
    ore.AssemblyAngularVelocity = Vector3.zero
    ore.CFrame = beam.CFrame

    task.wait(1/120)

    for i = 1, times do
        -->> Break if the beam has been removed during looping
        if not (beam and beam.Parent) then break end
        ore.CFrame = beam.CFrame
        pcall(firetouchinterest, ore, beam, 0)
        pcall(firetouchinterest, ore, beam, 1)
        task.wait()
    end
end

-->> Pass across non-resetter upgraders
local function passThroughUpgraders(ore, skipBeam)
    local function isLoopBeam(b)
        if not (b and b.Parent) then return false end
        local name = (b.Parent and b.Parent.Parent and b.Parent.Parent.Name) or b.Name

        local ok, neg = pcall(function()
            return getNegativeEffectCached(name)
        end)
        if ok and neg == "limit" then return true end


        local p = PRIORITY[name]
        if p and p.maxValue ~= nil then return true end

        return false
    end

    local function isResetBeam(b)
        if not (b and b.Parent) then return false end

        local name = (b.Parent and b.Parent.Parent and b.Parent.Parent.Name) or b.Name
        local ok, res = pcall(function()
            return isResetterCached(name)
        end)

        return ok and res == true
    end
    for _, beam in ipairs(upgraderBeams) do
        if beam and beam.Parent then
            local shouldSkip = isResetBeam(beam)

            if skipBeam then
                if beam == skipBeam or isLoopBeam(beam) then
                    shouldSkip = true
                end
            end

            if not shouldSkip then
                ore.AssemblyLinearVelocity = Vector3.zero
                ore.AssemblyAngularVelocity = Vector3.zero
                ore.CFrame = beam.CFrame

                pcall(firetouchinterest, ore, beam, 0)
                pcall(firetouchinterest, ore, beam, 1)
                task.wait(1/60)
            end
        end
    end
    -->> Extra frame on last because some upgraders may not register the last touch.
    local last = upgraderBeams[#upgraderBeams]
    if last and last.Parent then
        -->> Skip last if loops are being skipped and it is a loop
        local skipLast = false
        
        if skipBeam then
            if last == skipBeam or isLoopBeam(last) then
                skipLast = true
            end
        end

        if not skipLast then
            ore.AssemblyLinearVelocity = Vector3.zero
            ore.AssemblyAngularVelocity = Vector3.zero
            ore.CFrame = last.CFrame
            pcall(firetouchinterest, ore, last, 0)
            pcall(firetouchinterest, ore, last, 1)
            task.wait(1/30)
        end
    end
end

function oreBoost()
    if not furnace then print("no furnace") findFurnaces() end
    -->> Ensure the upgrader list is up to date
    if #upgraderBeams == 0 then
        -->> If the list is empty, schedule a rescan
        scheduleRescan(0)
    end

    --[[
        If no resetters are currently cached, attempt a synchronous rescan.
        Sometimes a resetter may be placed but missed by the asynchronous
        ChildAdded debounced rescan due to Roblox initialisation timing.
    ]]

    if #CACHED_RESETTERS == 0 then
        pcall(rescanAndSortUpgraders)
    end

    if LOOP_MODE_ENABLED and not CACHED_LIMIT_BEAM then
        pcall(rescanAndSortUpgraders)
        if not CACHED_LIMIT_BEAM then
            return
        end
    end

    for _, ore in ipairs(orePath:GetChildren()) do
        task.spawn(function()
            if ore:GetAttribute("Boosted") then return end
            ore:SetAttribute("Boosted", true)

            -->> Clean up fuck ass dreamer's terror leaf "ores"
            if not ore:FindFirstChild("OreInfo") then
                ore.CFrame = factoryName.Base.CFrame
            end

            if not ore:FindFirstChild("Fuel") and ore:FindFirstChild("OreInfo") and furnace ~= nil then
                -->> 1) If loop mode, do the limit looping *once first*
                local skip = nil
                if LOOP_MODE_ENABLED and CACHED_LIMIT_BEAM then
                    pcall(loopTouchUntilValue, ore, CACHED_LIMIT_BEAM, ACTIVE_LOOP_TARGET_VALUE)
                    skip = CACHED_LIMIT_BEAM
                end

                -->> 2) First setup pass
                passThroughUpgraders(ore, skip)

                -->> 3) For each resetter: touch resetter, then another setup pass
                if #CACHED_RESETTERS > 0 then
                    for _, resetBeam in ipairs(CACHED_RESETTERS) do
                        touchOnce(ore, resetBeam)
                        task.wait(1/30)
                        passThroughUpgraders(ore, skip)
                    end
                end

                -->> 4) Send to furnace
                ore.AssemblyLinearVelocity = Vector3.zero
                ore.AssemblyAngularVelocity = Vector3.zero
                ore.CFrame = furnace.CFrame + Vector3.new(0, 1, 0)
            end
        end)
    end
end



-- //=======================================================//







-- //=====================[ Custom Layout ]=====================//

local LAYOUT_PATH = "PhobisHub/Config/Layout1.json"
local layoutCache = nil
local autoLayoutConnection = nil
local LAYOUT_SCHEMA = 2 -->> 1, 2 = relative-to-base

local function cframeToTable(cf)
    local components = { cf:GetComponents() }
    return components
end

local function tableToCFrame(data)
    if typeof(data) == "CFrame" then
        return data
    end

    if type(data) ~= "table" then
        return nil
    end

    if #data >= 12 then
        for i = 1, 12 do
            if type(data[i]) ~= "number" then
                return nil
            end
        end

        return CFrame.new(table.unpack(data, 1, 12))
    end

    return nil
end

local function getPlacementPart(model)
    return model:FindFirstChild("Hitbox") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
end

local function collectPlacedItems()
    local items = {}
    local base = factoryName and factoryName:FindFirstChild("Base")

    if not base or not base:IsA("BasePart") then
        warn("[Save Layout] Missing factoryName.Base; cannot compute relative CFrames")
        return items
    end

    local baseCF = base.CFrame

    for _, model in ipairs(factoryName:GetChildren()) do
        if not model:FindFirstChild("ItemId") then
            continue
        end
        local hitbox = getPlacementPart(model)
        if not hitbox then
            continue
        end

        -->> Store RELATIVE to the baseplate
        local rel = baseCF:ToObjectSpace(hitbox.CFrame)

        table.insert(items, {
            Name = model.Name,
            RelCFrame = rel,
        })
    end

    return items
end


local function encodeLayout(items)
    local serialized = { schema = LAYOUT_SCHEMA, items = {} }

    for _, item in ipairs(items) do
        local cf = item.RelCFrame or item.CFrame -->> prefer relative
        if typeof(cf) == "CFrame" then
            table.insert(serialized.items, {
                Name = item.Name,
                RelCFrame = cframeToTable(cf) -->> store RELATIVE data
            })
        end
    end

    return serialized
end


local function decodeLayout(data)
    local out = {}

    if type(data) ~= "table" then return out end

    local schema = data.schema
    local list = data.items or data

    if type(list) ~= "table" then return out end

    for _, item in ipairs(list) do
        if type(item) ~= "table" then continue end

        if schema == 2 then
            -->> Relative format
            local cf = tableToCFrame(item.RelCFrame)
            if item.Name and cf then
                table.insert(out, { Name = item.Name, RelCFrame = cf })
            end
        end
    end

    return out
end

local function readLayoutFromDisk()
    if isfile and not isfile(LAYOUT_PATH) then return nil end
    local ok, contents = pcall(readfile, LAYOUT_PATH)
    if not ok then
        warn("[Layout] Failed to read layout file:", contents)
        return nil
    end
    local success, decoded = pcall(HttpService.JSONDecode, HttpService, contents)
    if not success then
        warn("[Layout] Failed to decode layout JSON:", decoded)
        return nil
    end
    local layout = decodeLayout(decoded)
    if #layout == 0 then
        warn("[Layout] Layout file is empty or invalid.")
        return nil
    end
    return layout
end


local function writeLayoutToDisk(items)
    local payload = encodeLayout(items)
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, payload)
    if not ok then
        warn("[Layout] Failed to encode layout JSON:", encoded)
        return false
    end
    local ok2, err = pcall(writefile, LAYOUT_PATH, encoded)
    if not ok2 then
        warn("[Layout] Failed to write layout file:", err)
        return false
    end
    return true
end


local function ensureLayoutCache(forceReload)
    if forceReload or not layoutCache then
        layoutCache = readLayoutFromDisk()
    end

    return layoutCache
end

local function PlaceItem(itemName, relCFrameData)
    local relCF = tableToCFrame(relCFrameData)
    if not relCF then
        warn(("[PlaceItem] Skipping %s; invalid relative CFrame."):format(tostring(itemName)))
        return
    end

    local base = factoryName and factoryName:FindFirstChild("Base")
    if not base or not base:IsA("BasePart") then
        warn("[PlaceItem] Missing factoryName.Base; cannot place")
        return
    end

    local targetWorldCF = base.CFrame * relCF

    task.spawn(function()
        ReplicatedStorage.PlaceItem:InvokeServer(itemName, targetWorldCF, { base })
    end)
end

local function PlaceLayout(items)
    if not items then return end
    local base = factoryName and factoryName:FindFirstChild("Base")
    if not base or not base:IsA("BasePart") then
        warn("[Auto Layout] Missing factoryName.Base; cannot place")
        return
    end

    ReplicatedStorage.FetchInventory:InvokeServer()

    for _, item in ipairs(items) do
        PlaceItem(item.Name, item.RelCFrame or item.CFrame)
        task.wait(0.1)
    end
end


-- //=======================================================//









-- //=====================[ UI Library ]=====================//

local Rayfield = loadstring(game:HttpGet('https://pastebin.com/raw/Fw4rqWgG'))()

local Window = Rayfield:CreateWindow({
   Name = "Biners Baven Menu",
   Icon = "armchair",
   LoadingTitle = "Brought to you by Bobis",
   LoadingSubtitle = "and Blangdong",
   ShowText = "BlangdongInc.",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/
      RememberJoins = true 
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"Hello"}
   }
})

local OreBoostTab = Window:CreateTab("Ore Booster", "blocks") -->> Title, Image
local CrateTab = Window:CreateTab("Crates", 4483362458)
local UtilsTab = Window:CreateTab("Utils", "anvil") 
local DebugTab = Window:CreateTab("Debug")

local rebirths = plr:WaitForChild("Rebirths")

-- //=====================[ Ore Booster Tab ]=====================//

local OreBoostSection = OreBoostTab:CreateSection("Ore Boosting")

local OreBoostToggle = OreBoostTab:CreateToggle({
   Name = "Ore Booster",
   CurrentValue = false,
   Flag = "oreboostmode", -->> A flag is the identifier for the configuration file
   Callback = function(CurrentValue)
        if CurrentValue then
            -->> When enabling the ore booster, make sure we know where the furnace is and rescan the factory for upgraders.
            findFurnaces()
            -->> Use scheduleRescan to avoid overlapping rescans if other events occur at the same time.
            scheduleRescan(0)
            startLoop("oreBoost", function() if CurrentValue then oreBoost() end end)
        else
            stopLoop("oreBoost")
            table.clear(CACHED_RESETTERS)
        end
   end,
})

local LoopModeToggle = OreBoostTab:CreateToggle({
   Name = "Loop Mode",
   CurrentValue = false,
   Flag = "loopmode", 
   Callback = function(CurrentValue)
        if CurrentValue then
            scheduleRescan(0)
            if CACHED_LIMIT_BEAM then
                -- print("[Loop Mode] Found limit upgrader:", CACHED_LIMIT_BEAM:GetFullName())
            else
                -- print("[Loop Mode] No limit upgrader found.")
            end
        else
            -->> Clear the loop cache and reset the hit count
            CACHED_LIMIT_BEAM = nil
            -- print("[Loop Mode] Disabled; cache cleared.")
        end
   end,
})

local RebirthSection = OreBoostTab:CreateSection("Rebirths")
local AutoRebirthToggle = OreBoostTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "autorebirthmode", 
   Callback = function(CurrentValue)
        if CurrentValue then startLoop("rebirth", rebirth, 0.75) else stopLoop("rebirth") end
   end,
})
local SkipToggle = OreBoostTab:CreateToggle({
   Name = "Auto Skip",
   CurrentValue = false,
   Flag = "autoskipmode", 
   Callback = function(CurrentValue)
        skipToggleValue = CurrentValue
   end,
})

skipToggleValue = SkipToggle.CurrentValue

local SkipSlider = OreBoostTab:CreateSlider({
   Name = "# of Skips",
   Range = {1, 20},
   Increment = 1,
   Suffix = "Skips",
   CurrentValue = 17,
   Flag = "skipslider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        allowedSkips = Value
   end,
})

allowedSkips = SkipSlider.CurrentValue


local selectedSlipstream = "None"

local SlipStreamToggle = OreBoostTab:CreateToggle({
   Name = "Obtain Slipstream",
   CurrentValue = false,
   Flag = "autoslipstreammode", 
   Callback = function(CurrentValue)
        -- selectedSlipstream = SlipStreamDropdown.CurrentOption
   end,
})

local SlipStreamDropdown = OreBoostTab:CreateDropdown({
   Name = "Select Slipstream",
   Options = {"Pulsar Octagnium Mine", "The Great Parasite", "Incendium Mine", "Utopian Refiner", "Dystopian Refiner", "Nature's Enchantment", "Burst Refiner", "Ore Supernova", "The Grand Prism", "Oblivion Weaver", "Neutropian Refiner", "Suitopian Refiner", "Behemoth Blossom", "Orbital Cataclysm", "Sinister Sepulcher"},
   CurrentOption = "None",
   Flag = "slipstreamoptions", 
   Callback = function(Option)
       for i,v in pairs(Option) do
            selectedSlipstream = v
       end
   end,
})

do
    local configDir = "PhobisHub/Config"
    if type(isfolder) == "function" and not isfolder(configDir) then
        pcall(makefolder, configDir)
    end
end

local CustomLayoutSection = OreBoostTab:CreateSection("Custom Layout")
local CustomLayoutToggle = OreBoostTab:CreateToggle({
   Name = "Auto Layout",
   CurrentValue = false,
   Flag = "customlayoutmode", 
   Callback = function(CurrentValue)
        if CurrentValue then
            local layout = ensureLayoutCache(false)
            if not layout then
                warn("[Auto Layout] Save a layout first.")
                return
            end

            autoLayoutConnection = rebirths:GetPropertyChangedSignal("Value"):Connect(function()
                task.wait(0.1)

                local cached = ensureLayoutCache(false)
                if not cached then
                    warn("[Auto Layout] Layout unavailable; stopping.")
                    return
                end

                PlaceLayout(cached)
            end)

        else
            if autoLayoutConnection then
                autoLayoutConnection:Disconnect()
                autoLayoutConnection = nil
            end
        end
   end,
})

local SaveLayoutBtn = OreBoostTab:CreateButton({
   Name = "Save Layout",
   Callback = function()
        if not factoryName then
            warn("[Save Layout] No active factory; cannot save layout.")
            Rayfield:Notify({
                Title = "Layouts",
                Content = "No active factory; cannot save layout.",
                Duration = 6.5,
                Image = 4483362458,
            })
            return
        end

        local items = collectPlacedItems()
        if #items == 0 then
            warn("[Save Layout] No placed items found; layout not saved.")
            Rayfield:Notify({
                Title = "Layouts",
                Content = "No placed items found; layout not saved.",
                Duration = 6.5,
                Image = 4483362458,
            })
            return
        end

        local success = writeLayoutToDisk(items)
        if success then
            layoutCache = items
            print(("[Save Layout] Saved %d items (schema=%d, relative to Base)."):format(#items, LAYOUT_SCHEMA))

            Rayfield:Notify({
                Title = "Layouts",
                Content = "Layout saved successfully.",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
   end,
})

local LoadLayoutBtn = OreBoostTab:CreateButton({
   Name = "Load Layout",
   Callback = function()
        if not factoryName then
            warn("[Load Layout] No active factory; cannot load layout.")
            return
        end

        local layout = ensureLayoutCache(false)
        if not layout then
            warn("[Load Layout] No saved layout found.")
            return
        end

        PlaceLayout(layout)
   end,
})

-- //=====================[ Crates Tab ]=====================//

local CrateUtilSection = CrateTab:CreateSection("Crate Utils")

local CollectCratesToggle = CrateTab:CreateToggle({
   Name = "Collect Crates",
   CurrentValue = false,
   Flag = "collectcratemode",
   Callback = function(CurrentValue)
        if CurrentValue then startLoop("crate", function() if CurrentValue then touchBoxes() end end, 3)
        else stopLoop("crate") end
   end,
})

local selectedBoxes = {}

local OpenCrateToggle = CrateTab:CreateToggle({
   Name = "Auto Open Crates",
   CurrentValue = false,
   Flag = "opencratemode", 
   Callback = function(CurrentValue)
		startLoop("openbox", function() 
            if CurrentValue and #selectedBoxes > 0 then 
                for _, boxType in ipairs(selectedBoxes) do
                    openBox(boxType)
                end
            end 
        end)
   end,
})

local CrateSelection = CrateTab:CreateDropdown({
   Name = "| Select Crates",
   Options = {"Regular","Unreal", "Inferno", "Spectral", "Red Banded", "Luxury"},
   CurrentOption = {"Regular"},
   MultipleOptions = true,
   Flag = "opencrateoptions", 
   Callback = function(Options)
        print("Selected boxes:", table.concat(selectedBoxes, ", "))
   end,
})

selectedBoxes = CrateSelection.CurrentOption

-- //=====================[ Utils Tab ]=====================//

local UtilsTabSection = UtilsTab:CreateSection("Utilities")
local VirtualUser = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer
local antiAFKConnection = nil

local afkToggle = UtilsTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "antiafkmode", -- optional if you're using flags
    Callback = function(state)
        if state then
            antiAFKConnection = player.Idled:Connect(function()
                pcall(function()
                    VirtualUser:CaptureController()
                    if VirtualUser.ClickButton2 then
                        VirtualUser:ClickButton2(Vector2.new(0,0))
                    else
                        VirtualUser:Button2Down(Vector2.new(0,0))
                        task.wait(0.1)
                        VirtualUser:Button2Up(Vector2.new(0,0))
                    end
                end)
            end)
        else
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
                antiAFKConnection = nil
            end
        end
    end
})

afkToggle:Set(true)

local RejoinBtn = UtilsTab:CreateButton({
   Name = "Rejoin",
   Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")

        local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Server, Next = nil, nil
        local function ListServers(cursor)
            local Raw = game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or ""))
            return HttpService:JSONDecode(Raw)
        end

        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[math.random(1, (#Servers.data / 3))]
            Next = Servers.nextPageCursor
        until Server

        if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
        end
   end,
})

local VendorsTabSection = UtilsTab:CreateSection("Vendors")

local AelfrunBtn = UtilsTab:CreateButton({
   Name = "Aelfrun",
   Callback = function()
        local AelfrunPrompt = workspace.Map.WizardDude.Internal.ProximityPrompt or nil

        if AelfrunPrompt ~= nil then
            fireproximityprompt(AelfrunPrompt, 1, true)
        else
            print("Couldn't find Aelfrun")
        end
   end,
})

local MaskedManBtn = UtilsTab:CreateButton({
   Name = "Masked Man",
   Callback = function()
        local MaskedMan = workspace.Market.Internal.ProximityPrompt or nil

        if MaskedMan ~= nil then
            fireproximityprompt(MaskedMan, 1, true)
        else
            print("Couldn't find masked man")
        end
   end,
})

local DraedonBtn = UtilsTab:CreateButton({
   Name = "Draedon",
   Callback = function()
        local Draedon = workspace.Map.Draedon.Internal.ProximityPrompt or nil

        if Draedon ~= nil then
            fireproximityprompt(Draedon, 1, true)
        else
            print("Couldn't find draedon")
        end
   end,
})


local DebugTabSection = DebugTab:CreateSection("Debug Info")
local DebugBtn = DebugTab:CreateButton({
   Name = "Debug Button",
   Callback = function()
        local layout = ensureLayoutCache(false)

        if factoryName and factoryName:FindFirstChild("Base") then
            local base = factoryName.Base
             for _, item in ipairs(layout) do
                print(item.Name)
                task.wait(0.1)
            end
        end
        
   end,
})

-- //=======================================================//

-->> Maybe custom UI

if plr.PlayerGui.GUI2.ItemPreview.Frame.Objects:FindFirstChild("PriorityUI") then
    plr.PlayerGui.GUI2.ItemPreview.Frame.Objects.PriorityUI:Destroy()
end

local PriorityUI = plr.PlayerGui.GUI2.ItemPreview.Frame.Objects.Sell:Clone()
PriorityUI.Name = "PriorityUI"
PriorityUI.Parent = plr.PlayerGui.GUI2
PriorityUI.Desc.Text = "Priority Menu"
PriorityUI.Key.Text = "G"

PriorityUI.Size = UDim2.new(0.9, 0, 0.2, 0)

local currentlySelectedItem = nil

PriorityUI.MouseButton1Click:Connect(function()
    print("[PriorityUI] Clicked")
end)

startLoop("priorityui", function()
    local gui = plr.PlayerGui
    if not gui then task.wait() return end

    local gui2 = gui:FindFirstChild("GUI2")
    if not gui2 then task.wait() return end

    local itemPreview = gui2:FindFirstChild("ItemPreview")
    if not itemPreview then task.wait() return end

    local frameContainer = itemPreview:FindFirstChild("Frame")
    if not frameContainer then task.wait() return end

    -- Ensure PhobisHubFrm exists under the same parent as the ItemPreview.Frame so it's visually underneath.
    local parentContainer = frameContainer.Parent or gui2
    parentContainer.ClipsDescendants = false
    local phFrame = parentContainer:FindFirstChild("PhobisHubFrm")
        if not phFrame then
        phFrame = Instance.new("Frame")
        phFrame.Name = "PhobisHubFrm"
        phFrame.ZIndex = 0
        phFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
        phFrame.BackgroundTransparency = 0
            phFrame.AnchorPoint = Vector2.new(0, 0)
                -- start hidden; visibility is toggled around tweens so it doesn't linger
                phFrame.Visible = false
            -- Add slight padding inside the frame (if not already present)
                if not phFrame:FindFirstChildOfClass("UIPadding") then
                    local pad = Instance.new("UIPadding")
                    pad.PaddingTop = UDim.new(0, 2)
                    pad.PaddingLeft = UDim.new(0, 6)
                    pad.PaddingRight = UDim.new(0, 6)
                    pad.Parent = phFrame
                end
                -- Ensure there's a vertical UIListLayout for child controls
                if not phFrame:FindFirstChildOfClass("UIListLayout") then
                    local list = Instance.new("UIListLayout")
                    list.FillDirection = Enum.FillDirection.Vertical
                    list.SortOrder = Enum.SortOrder.LayoutOrder
                    list.Padding = UDim.new(0, 2)
                    list.Parent = phFrame
                end
        phFrame.Parent = parentContainer
        -- Parent PriorityUI into phFrame and make it layout-friendly
        if PriorityUI.Parent ~= frameContainer.Objects then
            PriorityUI.Parent = frameContainer.Objects
        end
        -- Set a reasonable size that works with UIListLayout (full width minus padding)
        -- PriorityUI.Size = UDim2.new(1, -12, 0, 36)
        PriorityUI.Position = UDim2.new(0.5, 0, 0.75, 47)
        -- PriorityUI.LayoutOrder = 1

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.1, 0)
        corner.Parent = phFrame
    end

    -- Update currentlySelectedItem from the preview frame
    local sel = nil
    local objectVal = frameContainer:FindFirstChild("Object")
    if objectVal and objectVal.Value ~= nil then
        sel = objectVal.Value
    end
    currentlySelectedItem = sel

    -- Simple: place phFrame directly below the preview parent, same width as parent, height = ~1/4 parent
    local parentPos, parentSize, localY, width, height
    if parentContainer and parentContainer.AbsolutePosition and parentContainer.AbsoluteSize
    and frameContainer.AbsolutePosition and frameContainer.AbsoluteSize then
        parentPos = parentContainer.AbsolutePosition
        parentSize = parentContainer.AbsoluteSize

        localY = math.floor(frameContainer.AbsolutePosition.Y - parentPos.Y + frameContainer.AbsoluteSize.Y - 17)
        width = math.max(36, math.floor(parentSize.X))         -- same width as parent (min 36)
        height = math.max(36, math.floor(parentSize.Y * 0.25)) -- ~1/4 of parent height (min 36)

        phFrame.Position = UDim2.new(0, 0, 0, localY)
        phFrame.Size = UDim2.new(0, width, 0, height)
    end

    -- Visible and tween behaviour:
    -- We animate phFrame's height from 0 (closed) to target height when selection appears.
    do
        local sel = currentlySelectedItem
        local prevOpen = phFrame:GetAttribute("Phobis_PrevOpen") or false

        -- Defensive guards: ensure parentSize is available before indexing .Y
        local targetHeight = 36
        local targetWidth = 36
        if parentSize then
            targetHeight = math.max(36, math.floor(parentSize.Y * 0.25)) -- desired open height
            targetWidth = math.max(36, math.floor(parentSize.X))
        end

        -- Ensure position and width are applied immediately; height is controlled by tween
        if localY then
            phFrame.Position = UDim2.new(0, 0, 0, localY)
        end

        -- If phFrame currently has no meaningful height, ensure closed state
        local currentHeight = 0
        if phFrame.Size and phFrame.Size.Y and type(phFrame.Size.Y.Offset) == "number" then
            currentHeight = phFrame.Size.Y.Offset
        end
        phFrame.Size = UDim2.new(0, targetWidth, 0, currentHeight)

        if sel ~= nil and not prevOpen then
            -- Selection just became non-nil: schedule open after inventory UI finishes (~0.25s)
            phFrame:SetAttribute("Phobis_PrevOpen", true)
            local finalSize = UDim2.new(0, targetWidth, 0, targetHeight)
            task.spawn(function()
                -- Only open if selection still present
                if phFrame and currentlySelectedItem ~= nil then
                    -- make visible before tweening open
                    phFrame.Visible = true
                    local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    pcall(function()
                        local tw = TweenService:Create(phFrame, info, { Size = finalSize })
                        tw:Play()
                    end)
                end
            end)

        elseif sel == nil and prevOpen then
            -- Selection cleared: schedule a short delayed close to avoid transient nils
            -- Only close if selection remains cleared after the brief delay.
            task.spawn(function()
                task.wait(0.1)
                local stillSelected = false
                -- Re-check the preview Object to see if a new selection appeared
                local ok, obj = pcall(function() return frameContainer and frameContainer:FindFirstChild("Object") end)
                if ok and obj and obj.Value ~= nil then
                    stillSelected = true
                end
                if stillSelected then
                    -- A new selection arrived; don't close
                    return
                end

                -- Proceed to close now that selection is still cleared
                local closedSize = UDim2.new(0, targetWidth, 0, 0)
                local info = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                pcall(function()
                    local tw = TweenService:Create(phFrame, info, { Size = closedSize })
                    -- When close completes, hide and mark as closed
                    tw.Completed:Connect(function()
                        if phFrame then
                            phFrame.Visible = false
                            phFrame:SetAttribute("Phobis_PrevOpen", false)
                        end
                    end)
                    tw:Play()
                end)
            end)
        end
    end

    task.wait()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- ignore UI/Chat input
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.G and currentlySelectedItem then
        print("G key pressed!") -- callback
        print("--------")
        print(plr.PlayerGui.GUI2.ItemPreview.Frame.Object.Value)
    end
end)
-- //=====================[ Supervisor Loop ]=====================//


local function waitForLayoutCompletion(layout)
    local timeout = os.clock() + 10
    local placedCount = 0

    repeat
        placedCount = 0
        if factoryName and factoryName:FindFirstChild("Base") then
            local base = factoryName.Base
            for _, item in ipairs(layout) do
                if factoryName and factoryName:FindFirstChild(item.Name) then
                    -- print("[Supervisor] Confirmed placed: %s", item.Name)
                    placedCount = placedCount + 1
                end
            end
        end
        task.wait(0.2)

        if placedCount < #layout then
            -- warn("[Supervisor] Timeout waiting for layout to finish placing.")
        else
            task.wait() -->> Extra delay after confirmed placement
        end
        task.wait(0.2)
    until placedCount >= #layout or os.clock() > timeout

    if placedCount < #layout then
        warn("[Supervisor] Timeout waiting for layout to finish placing.")
    end
end

local function SupervisorLoop()
    local wasInRebirth = false
    local lastRebirth = plr.Rebirths.Value

    while true do
        task.wait(0.25)

        local rebirthOn = AutoRebirthToggle.CurrentValue
        local slipstreamOn = SlipStreamToggle.CurrentValue
        local layoutOn = CustomLayoutToggle.CurrentValue
        local boosterOn = OreBoostToggle.CurrentValue

        local currentRebirth = plr.Rebirths.Value
        if rebirthOn and currentRebirth > lastRebirth then
            wasInRebirth = true
            lastRebirth = currentRebirth

            stopLoop("oreBoost")

            if slipstreamOn and selectedSlipstream and selectedSlipstream ~= "None" then
                local hasSlip = searchInventory(selectedSlipstream)
                if hasSlip then
                    AutoRebirthToggle:Set(false)
                    OreBoostToggle:Set(false)
                    CustomLayoutToggle:Set(false)
                    SlipStreamToggle:Set(false)
                end
            end

            -->> Wait for layout placement if enabled
            if layoutOn then
                local cached = ensureLayoutCache(false)

                local timeout = os.clock() + 10
                repeat
                    if factoryName and factoryName:FindFirstChild("Base") then
                        break
                    end
                    task.wait(0.2)
                until os.clock() > timeout

                if cached and #cached > 0 and factoryName and factoryName:FindFirstChild("Base") then
                    PlaceLayout(cached)
                    waitForLayoutCompletion(cached)
                else
                    warn("[Supervisor] Layout skipped: factory or saved layout not available.")
                end
            end

            if boosterOn then
                findFurnaces()
                scheduleRescan(0.5)
                startLoop("oreBoost", oreBoost)
            end

            wasInRebirth = false
        end
    end
end

task.spawn(SupervisorLoop)


-- //=====================[ Stuff ]=====================//

-- Bind to the current active tycoon and listen for changes.  This must be
-- performed after rescanAndSortUpgraders is defined so that scheduleRescan
-- calls correctly reference the function.  bindFactory will refresh caches
-- and attach listeners on the new factory.

-- Whenever the player places or removes items on their factory we want to
-- rebuild the upgrader list.  Listen to ChildAdded and ChildRemoved events
-- for objects with an ItemType value.  We defer the call to rescan to allow
-- Roblox to finish initializing the model before scanning.


bindFactory(plr.PlayerTycoon.Value)
plr.PlayerTycoon:GetPropertyChangedSignal("Value"):Connect(function()
    bindFactory(plr.PlayerTycoon.Value)
end)
