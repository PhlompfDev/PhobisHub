
-->> get_skips.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getMoneyValue(plr)
    if not plr then return nil end
    local mirror = ReplicatedStorage:FindFirstChild("MoneyMirror")

    if not mirror then return nil end
    local node = mirror:FindFirstChild(plr.Name)

    if not node then return nil end
    if node and node:IsA("NumberValue") then
        return node.Value
    end
    return nil
end

--[[

Notes:

    - pcall(require, lib): prevents a thrown error in require() from crashing
        the script. The boolean "ok" indicates success and the second return
        value is either the module or an error message.
    - Type checks (is table, has LifeSkips function): modules can return
        arbitrary values. Checking the shape prevents runtime indexing/call errors
        if the game updates or the module changes.

]]

local function getAvailableSkips(plr)
    if not plr then return nil end
    local money = getMoneyValue(plr) or 0

    local lib = ReplicatedStorage:FindFirstChild("MoneyLib")
    if lib then
        local ok, MoneyLib = pcall(function() return require(lib) end)
        if ok and type(MoneyLib) == "table" and type(MoneyLib.LifeSkips) == "function" then
            local ok2, skips = pcall(function() return MoneyLib.LifeSkips(plr, money) end)
            if ok2 and type(skips) == "number" then
                return skips
            end
        end
    end
end

return getAvailableSkips 
