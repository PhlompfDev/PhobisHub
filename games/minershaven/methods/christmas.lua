local helper = import("games/minershaven/modules/gifts/present_helper", 1)

local chr = game.Players.LocalPlayer.Character
local hrp = chr.HumanoidRootPart

local santerclaws = workspace.Map:FindFirstChild("SantaModel").Santa

local myFactoryName = tostring(game.Players.LocalPlayer:WaitForChild("PlayerTycoon").Value)
local Tycoons = workspace:WaitForChild("Tycoons")

local Event = game:GetService("ReplicatedStorage").EventControllers.Christmas.CashInGift


local PAD_XZ = 6
local FIXED_Y = 60

local function ensureZone(factoryModel: Model)
	local bboxCFrame, bboxSize = factoryModel:GetBoundingBox()

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

	-- Keep it centered on the factory’s bbox.
	-- If using FIXED_Y, keep the center the same (simple + works fine for most tycoons).
	zone.CFrame = bboxCFrame

	-- Optional: if you want the zone to sit on the ground and extend upward:
	-- zone.CFrame = bboxCFrame * CFrame.new(0, (ySize - bboxSize.Y) * 0.5, 0)
end

local function tp(destination)
    hrp.CFrame = destination.CFrame
end

print("-------------")

for _, factory in ipairs(Tycoons:GetChildren()) do
	if factory:IsA("Model") then
		ensureZone(factory)
	end
end

for i, v in pairs(workspace:GetChildren()) do
	if v.Name == "CreatedPresent" then
		local present = v
		if helper:presentIsMine(Tycoons, present.CFrame, myFactoryName) then
			print("This present is mine.")

			tp(present)
			task.wait(0.1)

			fireproximityprompt(present.ProximityPrompt, 1, true)

			tp(santerclaws.Internal)
			task.wait(0.5)

			Event:InvokeServer()
		end
	end
end