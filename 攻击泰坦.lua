local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:SetTheme("Crimson")
local Window = WindUI:CreateWindow({
    Title = "攻击泰坦:帕拉迪斯",
    Icon = "door-open",
    Author = "Wscript",
    Folder = "Wscript",
    Size = UDim2.fromOffset(620, 460),
    Transparent = true,
    Theme = "Crimson",
    User = {
        Enabled = true,
        Callback = function() print("User clicked") end,
        Anonymous = false,
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
    HasOutline = true,
})
Window:SetBackgroundImage("")
Window:SetBackgroundImageTransparency(0.5)
Window:EditOpenButton({
    Title = "W",
    Icon = "",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true,
})
local fenv = getfenv()
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local function notify(title, content, duration)
    WindUI:Notify({
        Title = title,
        Content = content,
        Duration = duration or 2,
    })
end

local AnnounceTab = Window:Tab({
    Title = "公告",
    Icon = "app-window",
})
AnnounceTab:Paragraph({
    Title = "感谢(幼儿园扛把子)与(FIN)的技术指导",
    Desc = "",
})
AnnounceTab:Button({
    Title = "显示Q群",
    Callback = function()
        notify("Q群", "Q群:255244080", 5)
    end,
})
AnnounceTab:Paragraph({
    Title = "注入器：" .. (getexecutorname and getexecutorname() or "未知"),
    Desc = "",
})

local ProfileTab = Window:Tab({
    Title = "个人信息",
    Icon = "user",
})
ProfileTab:Paragraph({
    Title = "账号：" .. LocalPlayer.Name,
    Desc = "",
})
ProfileTab:Paragraph({
    Title = "启动时间：" .. os.date("%Y-%m-%d %H:%M:%S", os.time()),
    Desc = "",
})
ProfileTab:Paragraph({
    Title = "国家/地区：中国",
    Desc = "",
})
ProfileTab:Paragraph({
    Title = "服务器ID：" .. game.JobId,
    Desc = "",
})

local AttackTab = Window:Tab({
    Title = "攻击泰坦",
    Icon = "sword",
})

local isColossalSpam = false
local colossalThread = nil
local descendantConnection = nil

local function stopColossalSpam()
    isColossalSpam = false
    if colossalThread then
        task.wait(0.1)
        colossalThread = nil
    end
end

local function startColossalSpam()
    stopColossalSpam()
    local player = Players.LocalPlayer
    local gui = player:WaitForChild("PlayerGui")
    local function clearCooldowns()
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj.Name:match("CoolDown") then
                obj:Destroy()
            end
        end
    end
    clearCooldowns()
    if descendantConnection then descendantConnection:Disconnect() end
    descendantConnection = gui.DescendantAdded:Connect(function(obj)
        if obj.Name:match("CoolDown") then
            obj:Destroy()
        end
    end)
    local titanSelect = gui:FindFirstChild("TitanSelecting")
    if not titanSelect then
        titanSelect = gui:WaitForChild("TitanSelecting", 10)
        if not titanSelect then return end
    end
    local BUTTON_NAME = "Colossal"
    local btn = nil
    for _, child in ipairs(titanSelect:GetDescendants()) do
        if (child:IsA("TextButton") or child:IsA("ImageButton")) and child.Name == BUTTON_NAME then
            btn = child
            break
        end
    end
    if not btn then return end
    btn.Active = true
    btn.Interactable = true
    btn.Visible = true
    isColossalSpam = true
    colossalThread = task.spawn(function()
        while isColossalSpam do
            firesignal(btn.MouseButton1Down)
            task.wait(0.05)
            firesignal(btn.MouseButton1Up)
            task.wait(0.3)
        end
    end)
end

AttackTab:Toggle({
    Title = "超巨无冷却",
    Default = false,
    Callback = function(state)
        if state then
            startColossalSpam()
        else
            stopColossalSpam()
        end
    end,
})

local isRoarSpam = false
local roarThread = nil

local function stopRoarSpam()
    isRoarSpam = false
    if roarThread then
        task.wait(0.1)
        roarThread = nil
    end
end

local function startRoarSpam()
    stopRoarSpam()
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remote then remote = remote:FindFirstChild("RemoteEvents") end
    if remote then remote = remote:FindFirstChild("Combat") end
    if remote then remote = remote:FindFirstChild("Roar") end
    if not remote then return end
    isRoarSpam = true
    roarThread = task.spawn(function()
        while isRoarSpam do
            local args = {{move = "Roar"}}
            remote:FireServer(unpack(args))
            task.wait(0.02)
        end
    end)
end

AttackTab:Toggle({
    Title = "乱叫骚扰(全巨人通用)",
    Default = false,
    Callback = function(state)
        if state then
            startRoarSpam()
        else
            stopRoarSpam()
        end
    end,
})

local isSpikeSpam = false
local spikeThread = nil

local function stopSpikeSpam()
    isSpikeSpam = false
    if spikeThread then
        task.wait(0.1)
        spikeThread = nil
    end
end

local function startSpikeSpam()
    stopSpikeSpam()
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remote then remote = remote:FindFirstChild("RemoteEvents") end
    if remote then remote = remote:FindFirstChild("Combat") end
    if remote then remote = remote:FindFirstChild("PrimaryAbility") end
    if not remote then return end
    isSpikeSpam = true
    spikeThread = task.spawn(function()
        while isSpikeSpam do
            local args = {{move = "GroundSpikes"}}
            remote:FireServer(unpack(args))
            task.wait(0.8)
        end
    end)
end

AttackTab:Toggle({
    Title = "尖刺丛林(战锤)",
    Default = false,
    Callback = function(state)
        if state then
            startSpikeSpam()
        else
            stopSpikeSpam()
        end
    end,
})

local isGodModeSpam = false
local godModeThread = nil

local function stopGodModeSpam()
    isGodModeSpam = false
    if godModeThread then
        task.wait(0.1)
        godModeThread = nil
    end
end

local function startGodModeSpam()
    stopGodModeSpam()
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remote then remote = remote:FindFirstChild("RemoteEvents") end
    if remote then remote = remote:FindFirstChild("Combat") end
    if remote then remote = remote:FindFirstChild("Heal") end
    if not remote then return end
    isGodModeSpam = true
    godModeThread = task.spawn(function()
        while isGodModeSpam do
            local args = {{remoteName = "Heal", move = "Heal"}}
            remote:FireServer(unpack(args))
            task.wait(0.01)
        end
    end)
end

AttackTab:Toggle({
    Title = "上帝模式(巨人形态)",
    Default = false,
    Callback = function(state)
        if state then
            startGodModeSpam()
        else
            stopGodModeSpam()
        end
    end,
})