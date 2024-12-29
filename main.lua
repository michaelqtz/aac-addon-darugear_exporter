local api = require("api")

local darugear_exporter_addon = {
	name = "Daru Gear Exporter",
	author = "Michaelqt",
	version = "0.1",
	desc = "Export your character sheet to a Daru Gear file!"
}

local json --> helper library from https://github.com/Egor-Skriptunoff/json4lua

-- EQUIP_SLOT = {
--     HEAD = 0,
--     NECK = 0,
--     CHEST = 0,
--     WAIST = 0,
--     LEGS = 0,
--     HANDS = 0,
--     FEET = 0,
--     ARMS = 0,
--     BACK = 0,
--     EAR_1 = 0,
--     EAR_2 = 0,
--     FINGER_1 = 0,
--     FINGER_2 = 0,
--     UNDERSHIRT = 0,
--     UNDERPANTS = 0,
--     MAINHAND = 0,
--     OFFHAND = 0,
--     RANGED = 0,
--     MUSICAL = 0,
--     BACKPACK = 0,
--     COSPLAY = 0,
-- }

local function writeDarugearFile(path)
    -- The targetted gear slots to export
    local gearSlots = {
        EQUIP_SLOT.HEAD,
        EQUIP_SLOT.NECK,
        EQUIP_SLOT.CHEST,
        EQUIP_SLOT.WAIST,
        EQUIP_SLOT.HANDS,
        EQUIP_SLOT.LEGS,
        EQUIP_SLOT.ARMS,
        EQUIP_SLOT.FEET,
        EQUIP_SLOT.EAR_1,
        EQUIP_SLOT.BACK,
        EQUIP_SLOT.FINGER_1,
        EQUIP_SLOT.EAR_2,
        EQUIP_SLOT.UNDERSHIRT,
        EQUIP_SLOT.FINGER_2,
        EQUIP_SLOT.MAINHAND,
        EQUIP_SLOT.UNDERPANTS,
        EQUIP_SLOT.OFFHAND, 
        EQUIP_SLOT.RANGED,
        EQUIP_SLOT.MUSICAL, 
        EQUIP_SLOT.BACKPACK,
        EQUIP_SLOT.COSPLAY
    }
    local allGear = {}
    for _, i in ipairs(gearSlots) do
        local tooltipInfo = api.Equipment:GetEquippedItemTooltipInfo(i)
        local tooltipText = api.Equipment:GetEquippedItemTooltipText("player", i)
        allGear[i] = {}
        allGear[i]["info"] = tooltipInfo
        allGear[i]["text"] = tooltipText
        
    end 
    local allGearJson = json.encode(allGear)
    local fileContents = {gearJson=allGearJson}
    api.File:Write(path, fileContents)
end

local function OnLoad()
    local settings = api.GetSettings("darugear_exporter")
    json = require("darugear_exporter/json")

    local darugearFilePath = "darugear_export.txt"
    local btnX = -30
    local btnY = 55

    local characterInfoFrame = ADDON:GetContent(UIC.CHARACTER_INFO)
    local exportBtn = characterInfoFrame:CreateChildWidget("button", "exportBtn", 0, true)
    exportBtn:AddAnchor("TOPRIGHT", characterInfoFrame, btnX, btnY)
    exportBtn:SetText("Export Gear")
    api.Interface:ApplyButtonSkin(exportBtn, BUTTON_BASIC.DEFAULT)

    exportBtn:SetHandler("OnClick", function()
        writeDarugearFile(darugearFilePath)
        api.Log:Info("[DaruGear] Character export written to: " ..  "Documents/AAClassic/Addon/" .. darugearFilePath)
    end)

    -- chatWnd:GetChatEdit():SetText("Hello World\n")
    -- for key,value in pairs(getmetatable(chatWnd:GetChatEdit())) do
    --     api.Log:Info("found member " .. key .. " with value: " .. tostring(value));
    -- end
    -- for key,value in pairs(chatWnd:GetChatEdit()) do
    --     api.Log:Info("found member " .. key .. " with value: " .. tostring(value));
    -- end

    -- chatWnd:GetChatEdit():Show(true)
    -- chatWnd:GetChatEdit():SetFocus(true)
    -- chatWnd:GetChatEdit():ClearTextOnEnter(true)
    -- api.Log:Info(chatWnd)
    
    api.SaveSettings()
end 

local function OnUnload()
	local settings = api.GetSettings("darugear_exporter")
    local characterInfoFrame = ADDON:GetContent(UIC.CHARACTER_INFO)
    exportBtn = characterInfoFrame.exportBtn
    exportBtn:Show(false)
    exportBtn = nil


    api.SaveSettings()
end

darugear_exporter_addon.OnLoad = OnLoad
darugear_exporter_addon.OnUnload = OnUnload

return darugear_exporter_addon