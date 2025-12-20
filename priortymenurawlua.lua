-- // Gui 2 lua by vFishy / xn90ubwbzuqegtn \\ --

function createInstance(className, properties)
	local instance = Instance.new(className)
	for k, v in pairs(properties) do
		if typeof(k) ~= 'string' then
			continue
		end

		instance[k] = v
	end
	return instance
end
	

-- // Instances

local PriorityGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
PriorityGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local CanvasGroup = Instance.new("CanvasGroup")
CanvasGroup.Parent = PriorityGui


local Main = createInstance("Frame", {
    Name = "Main",
    Position = UDim2.new(0.000, 239.000, 0.000, 171.000),
    Size = UDim2.new(0.000, 442.000, 0.000, 318.000),
    Parent = CanvasGroup,
    BackgroundTransparency = 0.05000000074505806,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(27, 27, 27),
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIListLayout = createInstance("UIListLayout", {
    Parent = Main,
    Padding = UDim.new(0, 12),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local ConfigHolder = createInstance("Frame", {
    Name = "ConfigHolder",
    Position = UDim2.new(0.000, 0.000, 0.000, 73.000),
    Size = UDim2.new(0.000, 442.000, 0.000, 244.000),
    Parent = Main,
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 1
})

local ConfigScrollingFrame = createInstance("ScrollingFrame", {
    Name = "ConfigScrollingFrame",
    Position = UDim2.new(0.000, 1.000, 0.000, 33.000),
    Size = UDim2.new(0.000, 439.000, 0.000, 207.000),
    Parent = ConfigHolder,
    BackgroundTransparency = 1,
    ScrollBarThickness = 3,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ClipsDescendants = true,
    BackgroundColor3 = Color3.fromRGB(29, 30, 31),
    LayoutOrder = 3,
    BorderSizePixel = 0,
    ZIndex = 1
})

local DisplayTemplate = createInstance("Frame", {
    Name = "DisplayTemplate",
    Position = UDim2.new(-0.338, 0.000, 0.028, 0.000),
    Size = UDim2.new(1.574, 0.000, 0.189, 0.000),
    Parent = ConfigScrollingFrame,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    BorderSizePixel = 0,
    ZIndex = 2
})

local UICorner = createInstance("UICorner", {
    Parent = DisplayTemplate,
    CornerRadius = UDim.new(0, 7)
})

local UIStroke = createInstance("UIStroke", {
    Parent = DisplayTemplate,
    Color = Color3.fromRGB(39, 39, 39),
    Thickness = 1,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0
})

local DisplayDividerLeft = createInstance("Frame", {
    Name = "DisplayDividerLeft",
    Position = UDim2.new(0.000, 0.000, 0.309, 0.000),
    Size = UDim2.new(0.000, 299.000, 0.000, 15.000),
    Parent = DisplayTemplate,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 2
})

local UIPadding = createInstance("UIPadding", {
    Parent = DisplayDividerLeft,
    PaddingLeft = UDim.new(0.029999999329447746, 0)
})

local UIListLayout_1 = createInstance("UIListLayout", {
    Parent = DisplayDividerLeft,
    Padding = UDim.new(0, 5),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local ItemNameTemplate = createInstance("Frame", {
    Name = "ItemNameTemplate",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerLeft,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_2 = createInstance("UICorner", {
    Parent = ItemNameTemplate,
    CornerRadius = UDim.new(0.200000003, 0)
})

local ItemNameTitleLabel = createInstance("TextLabel", {
    Name = "ItemNameTitleLabel",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = ItemNameTemplate,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Item Name:',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_3 = createInstance("UIPadding", {
    Parent = ItemNameTitleLabel,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_4 = createInstance("UIListLayout", {
    Parent = ItemNameTemplate,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_5 = createInstance("UIPadding", {
    Parent = ItemNameTemplate,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local ItemNameValueTemplate = createInstance("Frame", {
    Name = "ItemNameValueTemplate",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerLeft,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_6 = createInstance("UICorner", {
    Parent = ItemNameValueTemplate,
    CornerRadius = UDim.new(0.200000003, 0)
})

local RawItemNameLabel = createInstance("TextLabel", {
    Name = "RawItemNameLabel",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = ItemNameValueTemplate,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Anguished Guardian Of The Gate',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_7 = createInstance("UIPadding", {
    Parent = RawItemNameLabel,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_8 = createInstance("UIListLayout", {
    Parent = ItemNameValueTemplate,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_9 = createInstance("UIPadding", {
    Parent = ItemNameValueTemplate,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local DisplayDividerRight = createInstance("Frame", {
    Name = "DisplayDividerRight",
    Position = UDim2.new(0.757, 0.000, 0.309, 0.000),
    Size = UDim2.new(0.000, 114.000, 0.000, 15.000),
    Parent = DisplayTemplate,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 2
})

local UIPadding_10 = createInstance("UIPadding", {
    Parent = DisplayDividerRight,
    PaddingLeft = UDim.new(0.029999999329447746, 0)
})

local UIListLayout_11 = createInstance("UIListLayout", {
    Parent = DisplayDividerRight,
    Padding = UDim.new(0, 5),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local PriorityValueTemplate = createInstance("Frame", {
    Name = "PriorityValueTemplate",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerRight,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 4,
    BorderSizePixel = 0,
    ZIndex = 0
})

local UICorner_12 = createInstance("UICorner", {
    Parent = PriorityValueTemplate,
    CornerRadius = UDim.new(0.200000003, 0)
})

local RawPriorityValueLabel = createInstance("TextLabel", {
    Name = "RawPriorityValueLabel",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = PriorityValueTemplate,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = '9999',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_13 = createInstance("UIPadding", {
    Parent = RawPriorityValueLabel,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_14 = createInstance("UIListLayout", {
    Parent = PriorityValueTemplate,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_15 = createInstance("UIPadding", {
    Parent = PriorityValueTemplate,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local PriorityTemplate = createInstance("Frame", {
    Name = "PriorityTemplate",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerRight,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 3,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_16 = createInstance("UICorner", {
    Parent = PriorityTemplate,
    CornerRadius = UDim.new(0.200000003, 0)
})

local PriorityTitleLabel = createInstance("TextLabel", {
    Name = "PriorityTitleLabel",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = PriorityTemplate,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Priority:',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_17 = createInstance("UIPadding", {
    Parent = PriorityTitleLabel,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_18 = createInstance("UIListLayout", {
    Parent = PriorityTemplate,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_19 = createInstance("UIPadding", {
    Parent = PriorityTemplate,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local UIListLayout_20 = createInstance("UIListLayout", {
    Parent = DisplayTemplate,
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIListLayout_21 = createInstance("UIListLayout", {
    Parent = ConfigScrollingFrame,
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_22 = createInstance("UIPadding", {
    Parent = ConfigScrollingFrame,
    PaddingTop = UDim.new(0.019999999552965164, 0),
    PaddingLeft = UDim.new(0.20000000298023224, 0),
    PaddingRight = UDim.new(0.20000000298023224, 0)
})

local UICorner_23 = createInstance("UICorner", {
    Parent = ConfigScrollingFrame,
    CornerRadius = UDim.new(0, 10)
})

local DisplayTemplate_24 = createInstance("Frame", {
    Name = "DisplayTemplate_24",
    Position = UDim2.new(-0.338, 0.000, 0.028, 0.000),
    Size = UDim2.new(1.574, 0.000, 0.189, 0.000),
    Parent = ConfigScrollingFrame,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    BorderSizePixel = 0,
    ZIndex = 2
})

local DisplayDividerRight_25 = createInstance("Frame", {
    Name = "DisplayDividerRight_25",
    Position = UDim2.new(0.757, 0.000, 0.309, 0.000),
    Size = UDim2.new(0.000, 114.000, 0.000, 15.000),
    Parent = DisplayTemplate_24,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 2
})

local UIPadding_26 = createInstance("UIPadding", {
    Parent = DisplayDividerRight_25,
    PaddingLeft = UDim.new(0.029999999329447746, 0)
})

local UIListLayout_27 = createInstance("UIListLayout", {
    Parent = DisplayDividerRight_25,
    Padding = UDim.new(0, 5),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local PriorityValueTemplate_28 = createInstance("Frame", {
    Name = "PriorityValueTemplate_28",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerRight_25,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 4,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_29 = createInstance("UICorner", {
    Parent = PriorityValueTemplate_28,
    CornerRadius = UDim.new(0.200000003, 0)
})

local RawPriorityValueLabel_30 = createInstance("TextLabel", {
    Name = "RawPriorityValueLabel_30",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = PriorityValueTemplate_28,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = '9999',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_31 = createInstance("UIPadding", {
    Parent = RawPriorityValueLabel_30,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_32 = createInstance("UIListLayout", {
    Parent = PriorityValueTemplate_28,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_33 = createInstance("UIPadding", {
    Parent = PriorityValueTemplate_28,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local PriorityTemplate_34 = createInstance("Frame", {
    Name = "PriorityTemplate_34",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerRight_25,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 3,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_35 = createInstance("UICorner", {
    Parent = PriorityTemplate_34,
    CornerRadius = UDim.new(0.200000003, 0)
})

local PriorityTitleLabel_36 = createInstance("TextLabel", {
    Name = "PriorityTitleLabel_36",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = PriorityTemplate_34,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Priority:',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_37 = createInstance("UIPadding", {
    Parent = PriorityTitleLabel_36,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_38 = createInstance("UIListLayout", {
    Parent = PriorityTemplate_34,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_39 = createInstance("UIPadding", {
    Parent = PriorityTemplate_34,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local UICorner_40 = createInstance("UICorner", {
    Parent = DisplayTemplate_24,
    CornerRadius = UDim.new(0, 7)
})

local UIStroke_41 = createInstance("UIStroke", {
    Parent = DisplayTemplate_24,
    Color = Color3.fromRGB(39, 39, 39),
    Thickness = 1,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0
})

local DisplayDividerLeft_42 = createInstance("Frame", {
    Name = "DisplayDividerLeft_42",
    Position = UDim2.new(0.000, 0.000, 0.309, 0.000),
    Size = UDim2.new(0.000, 299.000, 0.000, 15.000),
    Parent = DisplayTemplate_24,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 2
})

local ItemNameValueTemplate_43 = createInstance("Frame", {
    Name = "ItemNameValueTemplate_43",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerLeft_42,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_44 = createInstance("UICorner", {
    Parent = ItemNameValueTemplate_43,
    CornerRadius = UDim.new(0.200000003, 0)
})

local RawItemNameLabel_45 = createInstance("TextLabel", {
    Name = "RawItemNameLabel_45",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = ItemNameValueTemplate_43,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Garden of Gaia',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_46 = createInstance("UIPadding", {
    Parent = RawItemNameLabel_45,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_47 = createInstance("UIListLayout", {
    Parent = ItemNameValueTemplate_43,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_48 = createInstance("UIPadding", {
    Parent = ItemNameValueTemplate_43,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local UIPadding_49 = createInstance("UIPadding", {
    Parent = DisplayDividerLeft_42,
    PaddingLeft = UDim.new(0.029999999329447746, 0)
})

local UIListLayout_50 = createInstance("UIListLayout", {
    Parent = DisplayDividerLeft_42,
    Padding = UDim.new(0, 5),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local ItemNameTemplate_51 = createInstance("Frame", {
    Name = "ItemNameTemplate_51",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerLeft_42,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_52 = createInstance("UICorner", {
    Parent = ItemNameTemplate_51,
    CornerRadius = UDim.new(0.200000003, 0)
})

local ItemNameTitleLabel_53 = createInstance("TextLabel", {
    Name = "ItemNameTitleLabel_53",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = ItemNameTemplate_51,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Item Name:',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_54 = createInstance("UIPadding", {
    Parent = ItemNameTitleLabel_53,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_55 = createInstance("UIListLayout", {
    Parent = ItemNameTemplate_51,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_56 = createInstance("UIPadding", {
    Parent = ItemNameTemplate_51,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local UIListLayout_57 = createInstance("UIListLayout", {
    Parent = DisplayTemplate_24,
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local DisplayTemplate_58 = createInstance("Frame", {
    Name = "DisplayTemplate_58",
    Position = UDim2.new(-0.338, 0.000, 0.028, 0.000),
    Size = UDim2.new(1.574, 0.000, 0.189, 0.000),
    Parent = ConfigScrollingFrame,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    BorderSizePixel = 0,
    ZIndex = 2
})

local DisplayDividerRight_59 = createInstance("Frame", {
    Name = "DisplayDividerRight_59",
    Position = UDim2.new(0.757, 0.000, 0.309, 0.000),
    Size = UDim2.new(0.000, 114.000, 0.000, 15.000),
    Parent = DisplayTemplate_58,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 2
})

local UIPadding_60 = createInstance("UIPadding", {
    Parent = DisplayDividerRight_59,
    PaddingLeft = UDim.new(0.029999999329447746, 0)
})

local UIListLayout_61 = createInstance("UIListLayout", {
    Parent = DisplayDividerRight_59,
    Padding = UDim.new(0, 5),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local PriorityValueTemplate_62 = createInstance("Frame", {
    Name = "PriorityValueTemplate_62",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerRight_59,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 4,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_63 = createInstance("UICorner", {
    Parent = PriorityValueTemplate_62,
    CornerRadius = UDim.new(0.200000003, 0)
})

local RawPriorityValueLabel_64 = createInstance("TextLabel", {
    Name = "RawPriorityValueLabel_64",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = PriorityValueTemplate_62,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = '9999',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_65 = createInstance("UIPadding", {
    Parent = RawPriorityValueLabel_64,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_66 = createInstance("UIListLayout", {
    Parent = PriorityValueTemplate_62,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_67 = createInstance("UIPadding", {
    Parent = PriorityValueTemplate_62,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local PriorityTemplate_68 = createInstance("Frame", {
    Name = "PriorityTemplate_68",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerRight_59,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 3,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_69 = createInstance("UICorner", {
    Parent = PriorityTemplate_68,
    CornerRadius = UDim.new(0.200000003, 0)
})

local PriorityTitleLabel_70 = createInstance("TextLabel", {
    Name = "PriorityTitleLabel_70",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = PriorityTemplate_68,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Priority:',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_71 = createInstance("UIPadding", {
    Parent = PriorityTitleLabel_70,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_72 = createInstance("UIListLayout", {
    Parent = PriorityTemplate_68,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_73 = createInstance("UIPadding", {
    Parent = PriorityTemplate_68,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local UICorner_74 = createInstance("UICorner", {
    Parent = DisplayTemplate_58,
    CornerRadius = UDim.new(0, 7)
})

local UIStroke_75 = createInstance("UIStroke", {
    Parent = DisplayTemplate_58,
    Color = Color3.fromRGB(39, 39, 39),
    Thickness = 1,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0
})

local DisplayDividerLeft_76 = createInstance("Frame", {
    Name = "DisplayDividerLeft_76",
    Position = UDim2.new(0.000, 0.000, 0.309, 0.000),
    Size = UDim2.new(0.000, 299.000, 0.000, 15.000),
    Parent = DisplayTemplate_58,
    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 2
})

local ItemNameValueTemplate_77 = createInstance("Frame", {
    Name = "ItemNameValueTemplate_77",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerLeft_76,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_78 = createInstance("UICorner", {
    Parent = ItemNameValueTemplate_77,
    CornerRadius = UDim.new(0.200000003, 0)
})

local RawItemNameLabel_79 = createInstance("TextLabel", {
    Name = "RawItemNameLabel_79",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = ItemNameValueTemplate_77,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Astral Setter',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_80 = createInstance("UIPadding", {
    Parent = RawItemNameLabel_79,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_81 = createInstance("UIListLayout", {
    Parent = ItemNameValueTemplate_77,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_82 = createInstance("UIPadding", {
    Parent = ItemNameValueTemplate_77,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local UIPadding_83 = createInstance("UIPadding", {
    Parent = DisplayDividerLeft_76,
    PaddingLeft = UDim.new(0.029999999329447746, 0)
})

local UIListLayout_84 = createInstance("UIListLayout", {
    Parent = DisplayDividerLeft_76,
    Padding = UDim.new(0, 5),
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local ItemNameTemplate_85 = createInstance("Frame", {
    Name = "ItemNameTemplate_85",
    Position = UDim2.new(-0.000, 0.000, 0.239, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 20.000),
    Parent = DisplayDividerLeft_76,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(31, 31, 31),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_86 = createInstance("UICorner", {
    Parent = ItemNameTemplate_85,
    CornerRadius = UDim.new(0.200000003, 0)
})

local ItemNameTitleLabel_87 = createInstance("TextLabel", {
    Name = "ItemNameTitleLabel_87",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = ItemNameTemplate_85,
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansSemibold,
    Text = 'Item Name:',
    AutomaticSize = Enum.AutomaticSize.X,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(234, 234, 234),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIPadding_88 = createInstance("UIPadding", {
    Parent = ItemNameTitleLabel_87,
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 13)
})

local UIListLayout_89 = createInstance("UIListLayout", {
    Parent = ItemNameTemplate_85,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_90 = createInstance("UIPadding", {
    Parent = ItemNameTemplate_85,
    PaddingLeft = UDim.new(0.07999999821186066, 0)
})

local UIListLayout_91 = createInstance("UIListLayout", {
    Parent = DisplayTemplate_58,
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local ConfigTitleHolder = createInstance("Frame", {
    Name = "ConfigTitleHolder",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 240.000, 0.000, 15.000),
    Parent = ConfigHolder,
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(255, 0, 4),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIListLayout_92 = createInstance("UIListLayout", {
    Parent = ConfigTitleHolder,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_93 = createInstance("UIPadding", {
    Parent = ConfigTitleHolder,
    PaddingLeft = UDim.new(0.3100000023841858, 0)
})

local TextLabel = createInstance("TextLabel", {
    Name = "TextLabel",
    Position = UDim2.new(0.014, 0.000, -0.086, 0.000),
    Size = UDim2.new(-0.441, 0.000, 1.173, 0.000),
    Parent = ConfigTitleHolder,
    BackgroundTransparency = 1,
    Font = Enum.Font.Unknown,
    Text = 'Configuration',
    AutomaticSize = Enum.AutomaticSize.X,
    TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(134, 134, 175),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIStroke_94 = createInstance("UIStroke", {
    Parent = TextLabel,
    Color = Color3.fromRGB(72, 72, 94),
    Thickness = 1,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0.8399999737739563
})

local UIListLayout_95 = createInstance("UIListLayout", {
    Parent = ConfigHolder,
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local DividerFrame = createInstance("Frame", {
    Name = "DividerFrame",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 300.000, 0.000, 2.000),
    Parent = ConfigHolder,
    BackgroundColor3 = Color3.fromRGB(72, 72, 94),
    LayoutOrder = 2,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UICorner_96 = createInstance("UICorner", {
    Parent = Main,
    CornerRadius = UDim.new(0, 14)
})

local UIStroke_97 = createInstance("UIStroke", {
    Parent = Main,
    Color = Color3.fromRGB(24, 24, 24),
    Thickness = 2,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0.28999999165534973
})

local Frame = createInstance("Frame", {
    Name = "Frame",
    Position = UDim2.new(0.000, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 442.000, 0.000, 61.000),
    Parent = Main,
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    LayoutOrder = 1,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIListLayout_98 = createInstance("UIListLayout", {
    Parent = Frame,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_99 = createInstance("UIPadding", {
    Parent = Frame,
    PaddingTop = UDim.new(0.25, 0)
})

local ImageButton = createInstance("ImageButton", {
    Name = "ImageButton",
    Position = UDim2.new(0.145, 0.000, 0.000, 0.000),
    Size = UDim2.new(0.000, 185.000, 0.000, 32.000),
    Parent = Frame,
    BackgroundTransparency = 0.05000000074505806,
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    ImageColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
    ZIndex = 1
})

local LblHolder = createInstance("Frame", {
    Name = "LblHolder",
    Position = UDim2.new(0.000, 0.000, 0.266, 0.000),
    Size = UDim2.new(0.000, 0.000, 0.000, 15.000),
    Parent = ImageButton,
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Color3.fromRGB(255, 0, 4),
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIListLayout_100 = createInstance("UIListLayout", {
    Parent = LblHolder,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIPadding_101 = createInstance("UIPadding", {
    Parent = LblHolder,
    PaddingLeft = UDim.new(0.07000000029802322, 0)
})

local TextLabel_102 = createInstance("TextLabel", {
    Name = "TextLabel_102",
    Position = UDim2.new(0.014, 0.000, -0.086, 0.000),
    Size = UDim2.new(-0.441, 0.000, 1.173, 0.000),
    Parent = LblHolder,
    BackgroundTransparency = 1,
    Font = Enum.Font.Unknown,
    Text = 'Set As Primary Furnace',
    AutomaticSize = Enum.AutomaticSize.X,
    TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextWrapped = true,
    TextColor3 = Color3.fromRGB(190, 190, 190),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    BorderSizePixel = 0,
    ZIndex = 1
})

local UIListLayout_103 = createInstance("UIListLayout", {
    Parent = ImageButton,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
})

local UIStroke_104 = createInstance("UIStroke", {
    Parent = ImageButton,
    Color = Color3.fromRGB(255, 255, 255),
    Thickness = 3,
    LineJoinMode = Enum.LineJoinMode.Round,
    Transparency = 0
})

local sequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0, 0),
	NumberSequenceKeypoint.new(0.00249377, 0.85, 0),
	NumberSequenceKeypoint.new(0.925187, 0.73125, 0),
	NumberSequenceKeypoint.new(1, 0, 0)
})

local UIGradient = createInstance("UIGradient", {
    Parent = UIStroke_104,
    Rotation = -180,
    Color = ColorSequence.new({
    	ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 80, 82)),
    	ColorSequenceKeypoint.new(1, Color3.fromRGB(31, 31, 31)),
    }),
	Transparency = sequence
})

local UICorner_105 = createInstance("UICorner", {
    Parent = ImageButton
})
