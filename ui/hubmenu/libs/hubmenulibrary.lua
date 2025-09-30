local menulib = import("ui/prioritymenu/libs/prioritymenulibrary")

local HubLibrary = {}

function HubLibrary.supercoolfunction()
    print(menulib.coolfunction(1))
end

return HubLibrary