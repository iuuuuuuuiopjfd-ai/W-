local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:SetTheme("Crimson")
local Window = WindUI:CreateWindow({
    Title = "W吃掉其他玩家",
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
    Title = "感谢名字太长的技术指导",
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
AnnounceTab:Paragraph({
    Title = "目前支持的服务器",
    Desc = [[操作一（激活脚本前请现在训练场激活脚本）
Fling Things and People
TTK
死铁轨
血腥游乐场
W项目三角洲
项目三角洲(二份)
项目三角洲(三份)
萨凡纳（有密码）谨慎使用
恶魔学
海上100天
街头逼真的足球
征服欧洲二战
越狱
监狱鸟
lc莱克星顿
lc莱克星顿杀戮
死铁轨刷券
scp复古突破
scp复古突破A
Craft Blox(我的世界)
生锈的木筏
天空竞争者
天空竞争者2份
WW1B(有视觉 瞄准不好用 搭配WW1A)
WW1A(瞄准好用 没有视觉 搭配WW1B)
破坏者谜团2
暴力区
防御
失落前线
终极战场
国际足联超级足球
吃吃世界
感染性的微笑
按钮
按钮2(在局内执行)
监狱人生
森林中的99夜
流浪生存
僵尸实验室
攻击泰坦:帕拉迪斯
被遗弃
动物医院(异常情况)
迷你战争
犯罪行为]],
    Buttons = {},
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

local CollectTab = Window:Tab({
    Title = "自动吃/卖",
    Icon = "package",
})

local foodFolder = workspace.PickupItems.Food
local coinsFolder = workspace.PickupItems.Coins
local replicatedStorage = game:GetService("ReplicatedStorage")
local eventsFolder = replicatedStorage:WaitForChild("Events")
local attackRemote = eventsFolder:WaitForChild("AttackRemoteEvent")
local generalRemote = eventsFolder:WaitForChild("GeneralRemoteEvent")

local STAND_TIME = 0.5
local MAX_WAIT = 5
local EVENT_INTERVAL = 0.01

local isEating = false
local isRebirthing = false
local isCoinCollecting = false

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getFoodItems()
    local items = {}
    for _, child in ipairs(foodFolder:GetChildren()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            table.insert(items, child)
        end
    end
    return items
end

local function getTeleportPosition(obj)
    local pos
    if obj:IsA("BasePart") then
        pos = obj.Position
    elseif obj:IsA("Model") then
        local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if primary then pos = primary.Position end
    end
    return pos and pos + Vector3.new(0, 3, 0)
end

local function teleportTo(position)
    local root = getRoot()
    if root and root.Parent then
        root.CFrame = CFrame.new(position)
    end
end

local function startEatLoop()
    while isEating do
        local foodItems = getFoodItems()
        if #foodItems == 0 then
            task.wait(0.5)
            continue
        end

        local selected = foodItems[math.random(1, #foodItems)]
        if not selected or not selected.Parent then
            task.wait(0.2)
            continue
        end

        local telePos = getTeleportPosition(selected)
        if not telePos then
            continue
        end

        teleportTo(telePos)
        task.wait(STAND_TIME)

        local startTime = tick()
        while selected and selected.Parent and (tick() - startTime) < MAX_WAIT and isEating do
            attackRemote:FireServer("Chomp")
            task.wait(EVENT_INTERVAL)
        end

        if selected and selected.Parent then
            warn("[超时] 食物未消失，强制继续下一个")
        else
            print("[消失] 食物已消失，继续下一个")
        end
    end
end

local function startRebirthLoop()
    while isRebirthing do
        local args = { "Rebirth" }
        generalRemote:FireServer(unpack(args))
        task.wait(0.2)
    end
end

local function startCoinLoop()
    while isCoinCollecting do
        local children = coinsFolder:GetChildren()
        if #children >= 27 then
            local obj = children[27]
            if obj then
                local target = obj:FindFirstChild("AutoGeneratedPickupPart")
                if target and target.Parent then
                    local pos = target.Position + Vector3.new(0, 3, 0)
                    teleportTo(pos)
                    task.wait(0.05)
                    continue
                end
            end
        end
        task.wait(0.5)
    end
end

local function createToggle(parent, title, getFlag, setFlag, onStart)
    local methods = {"Toggle", "Switch", "Checkbox"}
    for _, method in ipairs(methods) do
        if parent[method] then
            local success, result = pcall(function()
                return parent[method](parent, {
                    Title = title,
                    Default = false,
                    Callback = function(state)
                        setFlag(state)
                        if state then
                            task.spawn(onStart)
                        end
                    end,
                })
            end)
            if success and result then
                print("成功创建控件：" .. method)
                return result
            end
        end
    end
    local btn = parent:Button({
        Title = "⏹ " .. title,
        Callback = function()
            local newState = not getFlag()
            setFlag(newState)
            btn:SetText((newState and "▶ " or "⏹ ") .. title)
            pcall(function() btn:SetBackgroundColor(newState and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,50,50)) end)
            if newState then
                task.spawn(onStart)
            end
        end,
    })
    pcall(function() btn:SetBackgroundColor(Color3.fromRGB(200,50,50)) end)
    return btn
end

createToggle(CollectTab, "自动吃", function() return isEating end, function(v) isEating = v end, startEatLoop)

createToggle(CollectTab, "自动重生", function() return isRebirthing end, function(v) isRebirthing = v end, startRebirthLoop)

createToggle(CollectTab, "自动金币", function() return isCoinCollecting end, function(v) isCoinCollecting = v end, startCoinLoop)

CollectTab:Button({
    Title = "一键卖所有",
    Callback = function()
        local args = { "ConvertFoodToCoins" }
        generalRemote:FireServer(unpack(args))
    end,
})

CollectTab:Button({
    Title = "回家",
    Callback = function()
        local root = getRoot()
        if root and root.Parent then
            root.CFrame = CFrame.new(-2.79, 12.06, -4.47)
        end
    end,
})