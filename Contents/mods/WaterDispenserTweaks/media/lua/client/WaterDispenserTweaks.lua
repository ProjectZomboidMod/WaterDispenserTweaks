WaterDispenserTweaks = {}

local Events = Events
local ISTakeWaterAction = ISTakeWaterAction
local ISTakeWaterActionFromTank = ISTakeWaterActionFromTank
local SandboxVars = SandboxVars
local ScriptManager = ScriptManager
local getActivatedMods = getActivatedMods

function WaterDispenserTweaks:init()
    self.SandboxVars = SandboxVars.WaterDispenserTweaks or {}
    self.SandboxVars.TakeWaterSpeedMultiplier = self.SandboxVars.TakeWaterSpeedMultiplier or 1
    self.SandboxVars.WaterJugEmptyWeight = self.SandboxVars.WaterJugEmptyWeight or 1
    self.SandboxVars.WaterJugWaterFullWeight = self.SandboxVars.WaterJugWaterFullWeight or 20
    self.SandboxVars.WaterJugWaterFullCapacity = self.SandboxVars.WaterJugWaterFullCapacity or 250
    self.SandboxVars.WaterJugPetrolFullWeight = self.SandboxVars.WaterJugPetrolFullWeight or 20
    self.SandboxVars.WaterJugPetrolFullCapacity = self.SandboxVars.WaterJugPetrolFullCapacity or 250

    self.WaterJugEmpty = "WaterDispenser.WaterJugEmpty"
    self.WaterJugWaterFull = "WaterDispenser.WaterJugWaterFull"
    self.WaterJugPetrolFull = "WaterDispenser.WaterJugPetrolFull"
    return self
end
local mod = WaterDispenserTweaks:init()
local activatedMods = getActivatedMods()

local ISTakeWaterAction_start = ISTakeWaterAction.start
function ISTakeWaterAction:start()
    ISTakeWaterAction_start(self)
    if self.item and self.item:getFullType() == mod.WaterJugWaterFull and mod.SandboxVars.TakeWaterSpeedMultiplier then
        -- self.action:setTime((self.waterUnit * 10) + 30)
        self.action:setTime((self.waterUnit * 10 / mod.SandboxVars.TakeWaterSpeedMultiplier) + 30)
    end
end

-- Tread's Water Tank Trucks
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2719592131
if activatedMods:contains("RS_WaterCistern") and ISTakeWaterActionFromTank and ISTakeWaterActionFromTank.start then
    local ISTakeWaterActionFromTank_start = ISTakeWaterActionFromTank.start
    function ISTakeWaterActionFromTank:start()
        ISTakeWaterActionFromTank_start(self)
        if self.item and self.item:getFullType() == mod.WaterJugWaterFull and mod.SandboxVars.TakeWaterSpeedMultiplier then
            -- self.action:setTime((self.waterUnit * 15) + 30)
            self.action:setTime((self.waterUnit * 15 / mod.SandboxVars.TakeWaterSpeedMultiplier) + 30)
        end
    end
end

function WaterDispenserTweaks:tweakItems()
    local sandboxVars = mod.SandboxVars
    local waterJugEmpty = ScriptManager.instance:getItem(mod.WaterJugEmpty)
    if waterJugEmpty then
        if sandboxVars.WaterJugEmptyWeight then
            waterJugEmpty:setActualWeight(sandboxVars.WaterJugEmptyWeight)
        end
    end

    local waterJugWaterFull = ScriptManager.instance:getItem(mod.WaterJugWaterFull)
    if waterJugWaterFull then
        if sandboxVars.WaterJugWaterFullWeight then
            waterJugWaterFull:setActualWeight(sandboxVars.WaterJugWaterFullWeight)
        end
        if sandboxVars.WaterJugWaterFullCapacity then
            waterJugWaterFull:setUseDelta(1 / sandboxVars.WaterJugWaterFullCapacity)
        end
    end

    local waterJugPetrolFull = ScriptManager.instance:getItem(mod.WaterJugPetrolFull)
    if waterJugPetrolFull then
        if sandboxVars.WaterJugPetrolFullWeight then
            waterJugPetrolFull:setActualWeight(sandboxVars.WaterJugPetrolFullWeight)
        end
        if sandboxVars.WaterJugPetrolFullCapacity then
            waterJugPetrolFull:setUseDelta(1 / sandboxVars.WaterJugPetrolFullCapacity)
        end
    end
end

Events.OnGameBoot.Add(mod.tweakItems)

-- Change Sandbox Options (by Star)
-- https://steamcommunity.com/sharedfiles/filedetails/?id=2894296454
if Events.OnSandboxOptionsChanged then
    Events.OnSandboxOptionsChanged.Add(mod.tweakItems)
end
