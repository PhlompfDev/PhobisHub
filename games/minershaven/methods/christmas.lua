-- getgenv().__Importer:invalidate("games/minershaven/modules/gifts/present_helper", true)
local helper = import("games/minershaven/modules/gifts/present_helper", 1)

local plr = game.Players.LocalPlayer
local chr = plr.Character
local hrp = chr.HumanoidRootPart

local santerclaws = workspace.Map:FindFirstChild("SantaModel").Santa

local myFactory = plr:WaitForChild("PlayerTycoon").Value
local Tycoons = workspace:WaitForChild("Tycoons")

local Event = game:GetService("ReplicatedStorage").EventControllers.Christmas.CashInGift

local function ensureZone(factoryModel: Model)
	local bboxCFrame, bboxSize = factoryModel:GetBoundingBox()
	local PAD_XZ = 6
	local FIXED_Y = 60

	local zone = factoryModel:FindFirstChild("Zone")
	if not zone then
		zone = Instance.new("Part")
		zone.Name = "Zone"
		zone.Anchored = true
		zone.CanCollide = false
		zone.CanQuery = false
		zone.CanTouch = false
		zone.Transparency = 1
		zone.Material = Enum.Material.SmoothPlastic
		zone.Parent = factoryModel
	end

	local ySize = FIXED_Y or (bboxSize.Y + 2)
	zone.Size = Vector3.new(
		bboxSize.X + PAD_XZ,
		ySize,
		bboxSize.Z + PAD_XZ
	)

	zone.CFrame = bboxCFrame
end


print("-------------")

for _, factory in ipairs(Tycoons:GetChildren()) do
	if factory:IsA("Model") then
		ensureZone(factory)
	end
end

_G.Swag = true

while _G.Swag == true do
	helper:dropOre(myFactory)

	task.wait(3)

	for i, v in pairs(workspace:GetChildren()) do
		if v.Name == "CreatedPresent" then
			local present = v
			if helper:presentIsMine(Tycoons, present.CFrame, tostring(myFactory)) then
				helper:tp(present)
				task.wait(0.1)

				fireproximityprompt(present.ProximityPrompt, 1, true)

				helper:tp(santerclaws.Internal)
				task.wait(0.5)

				Event:InvokeServer()
				helper:dropOre(myFactory)
				task.wait(15)
			end
		end
	end
end