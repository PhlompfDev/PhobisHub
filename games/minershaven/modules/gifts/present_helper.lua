local presentHelper = {}

-- Returns true if worldPoint lies inside the rotated box (zonePart)
function presentHelper:pointInOBB(zonePart: BasePart, worldPoint: Vector3, padding: number?)
	padding = padding or 0

	-- Convert point into the zone's local coordinate space
	local localPos = zonePart.CFrame:PointToObjectSpace(worldPoint)

	-- Half extents in local axes
	local half = (zonePart.Size * 0.5) + Vector3.new(padding, padding, padding)

	return math.abs(localPos.X) <= half.X
		and math.abs(localPos.Y) <= half.Y
		and math.abs(localPos.Z) <= half.Z
end

-- Finds the factory whose Zone contains the present position
function presentHelper:getFactoryFromPresentCFrame(factoriesFolder: Instance, presentCFrame: CFrame)
	local p = presentCFrame.Position

	for _, factory in ipairs(factoriesFolder:GetChildren()) do
		local zone = factory:FindFirstChild("Zone")
		if zone and zone:IsA("BasePart") then
			if self:pointInOBB(zone, p, 2) then
				return factory
			end
		end
	end

	return nil
end

-- Example "matches my factory" check
function presentHelper:presentIsMine(factoriesFolder: Instance, presentCFrame: CFrame, myFactoryName: string)
	local factory = self:getFactoryFromPresentCFrame(factoriesFolder, presentCFrame)
	return factory ~= nil and factory.Name == myFactoryName
end

function presentHelper:tp(destination)
    hrp.CFrame = destination.CFrame
end

function presentHelper:dropOre(myFactory)
	local dropper = myFactory:FindFirstChild("Silicon Excavator")
	if dropper and dropper.Model.Internal:FindFirstChild("ProximityPrompt") then
		self:tp(dropper.Hitbox)
		task.wait(0.5)
		fireproximityprompt(dropper.Model.Internal.ProximityPrompt, 1, true)
	end
end

return presentHelper