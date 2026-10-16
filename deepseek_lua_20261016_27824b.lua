--[[
    ╔══════════════════════════════════════╗
    ║      DRAXI FRUITS - HUB PREMIUM      ║
    ║         By DraxiLow                  ║
    ╚══════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

for _, v in pairs(pgui:GetChildren()) do
    if v.Name == "DraxiFruitsHub" then v:Destroy() end
end

local AZUL = Color3.fromRGB(0, 140, 255)
local AZUL_ESCURO = Color3.fromRGB(15, 25, 45)
local AZUL_CLARO = Color3.fromRGB(80, 180, 255)
local VERDE = Color3.fromRGB(50, 200, 100)
local VERMELHO = Color3.fromRGB(220, 60, 60)
local BRANCO = Color3.fromRGB(255, 255, 255)

local speedValues = {16, 120, 350}
local currentSpeed = 1
local espUsers = {}
local locked = false
local dragging = false
local dragStart, startPos
local activeSpin = nil
local activeStick = nil
local currentTab = "main"

local sg = Instance.new("ScreenGui")
sg.Name = "DraxiFruitsHub"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999
sg.IgnoreGuiInset = true
sg.Parent = pgui

local abrirBtn = Instance.new("TextButton")
abrirBtn.Name = "DraxiAbrir"
abrirBtn.Size = UDim2.new(0, 70, 0, 30)
abrirBtn.Position = UDim2.new(0.5, -35, 0.4, -15)
abrirBtn.BackgroundColor3 = AZUL_ESCURO
abrirBtn.BackgroundTransparency = 0.15
abrirBtn.Text = "Abrir"
abrirBtn.TextColor3 = BRANCO
abrirBtn.Font = Enum.Font.GothamBold
abrirBtn.TextSize = 13
abrirBtn.BorderSizePixel = 0
abrirBtn.Visible = false
abrirBtn.Parent = sg

local abrirCorner = Instance.new("UICorner", abrirBtn)
abrirCorner.CornerRadius = UDim.new(0, 8)
local abrirStroke = Instance.new("UIStroke", abrirBtn)
abrirStroke.Color = AZUL
abrirStroke.Thickness = 1.5

local draggingAbrir, dragStartAbrir, startPosAbrir
abrirBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingAbrir = true
        dragStartAbrir = input.Position
        startPosAbrir = abrirBtn.Position
    end
end)
abrirBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingAbrir = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingAbrir and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartAbrir
        abrirBtn.Position = UDim2.new(startPosAbrir.X.Scale, startPosAbrir.X.Offset + delta.X, startPosAbrir.Y.Scale, startPosAbrir.Y.Offset + delta.Y)
    end
end)

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 380, 0, 300)
frame.Position = UDim2.new(0.5, -190, 0.35, -150)
frame.BackgroundColor3 = AZUL_ESCURO
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = false
frame.Parent = sg

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)
local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = AZUL
frameStroke.Thickness = 2
frameStroke.Transparency = 0.2

local titleGlow = Instance.new("Frame")
titleGlow.Size = UDim2.new(0, 150, 0, 20)
titleGlow.Position = UDim2.new(0, 50, 0, 8)
titleGlow.BackgroundColor3 = AZUL
titleGlow.BackgroundTransparency = 0.75
titleGlow.BorderSizePixel = 0
titleGlow.ZIndex = 1
titleGlow.Parent = frame
local tgCorner = Instance.new("UICorner", titleGlow)
tgCorner.CornerRadius = UDim.new(1, 0)

local particulas = {}
for i = 1, 8 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, 4, 0, 4)
    p.BackgroundColor3 = AZUL_CLARO
    p.BorderSizePixel = 0
    p.ZIndex = 2
    p.Parent = frame
    local pc = Instance.new("UICorner", p)
    pc.CornerRadius = UDim.new(1, 0)
    p.Position = UDim2.new(0, 55 + math.random(0, 130), 0, 15)
    table.insert(particulas, p)
end

task.spawn(function()
    while sg.Parent do
        for _, p in pairs(particulas) do
            local nx = math.random(50, 180)
            local ny = math.random(5, 25)
            TweenService:Create(p, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                Position = UDim2.new(0, nx, 0, ny),
                BackgroundTransparency = math.random(30, 80)/100
            }):Play()
        end
        task.wait(1.2)
    end
end)

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(0, 200, 0, 24)
titulo.Position = UDim2.new(0, 45, 0, 6)
titulo.BackgroundTransparency = 1
titulo.Text = "Draxi Fruits"
titulo.TextColor3 = BRANCO
titulo.Font = Enum.Font.GothamBlack
titulo.TextSize = 18
titulo.ZIndex = 3
titulo.TextStrokeTransparency = 0.5
titulo.TextStrokeColor3 = AZUL
titulo.Parent = frame

task.spawn(function()
    while sg.Parent do
        local t1 = TweenService:Create(frameStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Color = AZUL_CLARO, Transparency = 0})
        t1:Play()
        t1.Completed:Wait()
        local t2 = TweenService:Create(frameStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Color = AZUL, Transparency = 0.4})
        t2:Play()
        t2.Completed:Wait()
    end
end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 22)
minBtn.Position = UDim2.new(1, -34, 0, 6)
minBtn.BackgroundColor3 = VERMELHO
minBtn.Text = "-"
minBtn.TextColor3 = BRANCO
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.BorderSizePixel = 0
minBtn.ZIndex = 4
minBtn.Parent = frame
local minCorner = Instance.new("UICorner", minBtn)
minCorner.CornerRadius = UDim.new(0, 6)

local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 26, 0, 22)
lockBtn.Position = UDim2.new(0, 8, 0, 6)
lockBtn.BackgroundColor3 = AZUL
lockBtn.Text = "🔓"
lockBtn.TextColor3 = BRANCO
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 14
lockBtn.BorderSizePixel = 0
lockBtn.ZIndex = 4
lockBtn.Parent = frame
local lockCorner = Instance.new("UICorner", lockBtn)
lockCorner.CornerRadius = UDim.new(0, 6)

frame.InputBegan:Connect(function(input)
    if locked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and not locked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(0, 360, 0, 26)
tabContainer.Position = UDim2.new(0, 10, 0, 36)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = frame

local function makeTabBtn(name, x, w)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 0, 24)
    b.Position = UDim2.new(0, x, 0, 0)
    b.BackgroundColor3 = AZUL_ESCURO
    b.BackgroundTransparency = 0.3
    b.Text = name
    b.TextColor3 = BRANCO
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.Parent = tabContainer
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 6)
    return b
end

local tabMain = makeTabBtn("Principal", 0, 85)
local tabESP = makeTabBtn("ESP", 90, 60)
local tabAttach = makeTabBtn("Grudar/Girar", 155, 100)
local tabServer = makeTabBtn("Servidores", 260, 90)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 360, 0, 210)
contentFrame.Position = UDim2.new(0, 10, 0, 66)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

local mainPage = Instance.new("Frame")
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.BackgroundTransparency = 1
mainPage.Parent = contentFrame

local speedLbl = Instance.new("TextLabel")
speedLbl.Size = UDim2.new(1, 0, 0, 22)
speedLbl.Position = UDim2.new(0, 0, 0, 4)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "⚡ Velocidade: Normal"
speedLbl.TextColor3 = AZUL_CLARO
speedLbl.Font = Enum.Font.GothamBold
speedLbl.TextSize = 14
speedLbl.Parent = mainPage

local function makeSpeedBtn(txt, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 100, 0, 34)
    b.Position = UDim2.new(0, x, 0, 34)
    b.BackgroundColor3 = AZUL_ESCURO
    b.BackgroundTransparency = 0.2
    b.Text = txt
    b.TextColor3 = BRANCO
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.Parent = mainPage
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = AZUL
    s.Thickness = 1
    return b
end

local bSp1 = makeSpeedBtn("1 Normal", 5)
local bSp2 = makeSpeedBtn("2 Rápido", 115)
local bSp3 = makeSpeedBtn("3 Super", 225)

local function setSpeedLevel(lvl)
    currentSpeed = lvl
    bSp1.BackgroundColor3 = (lvl == 1) and AZUL or AZUL_ESCURO
    bSp2.BackgroundColor3 = (lvl == 2) and AZUL or AZUL_ESCURO
    bSp3.BackgroundColor3 = (lvl == 3) and AZUL or AZUL_ESCURO
    speedLbl.Text = "⚡ Velocidade: " .. (lvl == 1 and "Normal" or lvl == 2 and "Rápido" or "Super")
end
setSpeedLevel(1)

bSp1.MouseButton1Click:Connect(function() setSpeedLevel(1) end)
bSp2.MouseButton1Click:Connect(function() setSpeedLevel(2) end)
bSp3.MouseButton1Click:Connect(function() setSpeedLevel(3) end)

local espPage = Instance.new("Frame")
espPage.Size = UDim2.new(1, 0, 1, 0)
espPage.BackgroundTransparency = 1
espPage.Visible = false
espPage.Parent = contentFrame

local closeEspBtn = Instance.new("TextButton")
closeEspBtn.Size = UDim2.new(0, 24, 0, 24)
closeEspBtn.Position = UDim2.new(1, -28, 0, 0)
closeEspBtn.BackgroundColor3 = VERMELHO
closeEspBtn.Text = "X"
closeEspBtn.TextColor3 = BRANCO
closeEspBtn.Font = Enum.Font.GothamBlack
closeEspBtn.TextSize = 14
closeEspBtn.BorderSizePixel = 0
closeEspBtn.ZIndex = 10
closeEspBtn.Parent = espPage
local xC = Instance.new("UICorner", closeEspBtn)
xC.CornerRadius = UDim.new(0, 6)

local espInput = Instance.new("TextBox")
espInput.Size = UDim2.new(0, 200, 0, 26)
espInput.Position = UDim2.new(0, 5, 0, 5)
espInput.BackgroundColor3 = AZUL_ESCURO
espInput.BackgroundTransparency = 0.2
espInput.TextColor3 = BRANCO
espInput.PlaceholderText = "Nome (ou 2 letras)..."
espInput.PlaceholderColor3 = Color3.fromRGB(150, 180, 220)
espInput.Text = ""
espInput.TextSize = 12
espInput.Font = Enum.Font.Gotham
espInput.BorderSizePixel = 0
espInput.ClearTextOnFocus = false
espInput.Parent = espPage
local espInputC = Instance.new("UICorner", espInput)
espInputC.CornerRadius = UDim.new(0, 6)
local espInputS = Instance.new("UIStroke", espInput)
espInputS.Color = AZUL
espInputS.Thickness = 1

local resultsFrame = Instance.new("Frame")
resultsFrame.Size = UDim2.new(0, 200, 0, 60)
resultsFrame.Position = UDim2.new(0, 5, 0, 36)
resultsFrame.BackgroundTransparency = 1
resultsFrame.Parent = espPage

local espListLbl = Instance.new("TextLabel")
espListLbl.Size = UDim2.new(1, -10, 0, 18)
espListLbl.Position = UDim2.new(0, 5, 0, 100)
espListLbl.BackgroundTransparency = 1
espListLbl.Text = "Pessoas com ESP:"
espListLbl.TextColor3 = AZUL_CLARO
espListLbl.Font = Enum.Font.GothamBold
espListLbl.TextSize = 12
espListLbl.TextXAlignment = Enum.TextXAlignment.Left
espListLbl.Parent = espPage

local espListFrame = Instance.new("Frame")
espListFrame.Size = UDim2.new(1, -10, 0, 100)
espListFrame.Position = UDim2.new(0, 5, 0, 120)
espListFrame.BackgroundColor3 = AZUL_ESCURO
espListFrame.BackgroundTransparency = 0.4
espListFrame.BorderSizePixel = 0
espListFrame.Parent = espPage
local elfC = Instance.new("UICorner", espListFrame)
elfC.CornerRadius = UDim.new(0, 8)

local espListLayout = Instance.new("UIListLayout", espListFrame)
espListLayout.Padding = UDim.new(0, 3)
espListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local espListPad = Instance.new("UIPadding", espListFrame)
espListPad.PaddingTop = UDim.new(0, 5)
espListPad.PaddingLeft = UDim.new(0, 5)

local function addESP(target)
    if espUsers[target] then return end
    local char = target.Character
    if not char then return end

    local hl = Instance.new("Highlight")
    hl.Name = "DraxiESP"
    hl.Adornee = char
    hl.FillColor = Color3.fromRGB(0, 150, 255)
    hl.OutlineColor = Color3.fromRGB(0, 220, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char

    local conn = target.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        if espUsers[target] then
            hl.Adornee = newChar
        end
    end)

    espUsers[target] = {highlight = hl, conn = conn}

    local entry = Instance.new("Frame")
    entry.Name = target.Name
    entry.Size = UDim2.new(1, -10, 0, 22)
    entry.BackgroundColor3 = AZUL
    entry.BackgroundTransparency = 0.6
    entry.BorderSizePixel = 0
    entry.Parent = espListFrame
    local ec = Instance.new("UICorner", entry)
    ec.CornerRadius = UDim.new(0, 5)

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(0.7, 0, 1, 0)
    nameL.Position = UDim2.new(0, 5, 0, 0)
    nameL.BackgroundTransparency = 1
    nameL.Text = target.DisplayName .. " (@" .. target.Name .. ")"
    nameL.TextColor3 = BRANCO
    nameL.Font = Enum.Font.Gotham
    nameL.TextSize = 11
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = entry

    local removeBtn = Instance.new("TextButton")
    removeBtn.Size = UDim2.new(0, 50, 0, 18)
    removeBtn.Position = UDim2.new(1, -55, 0, 2)
    removeBtn.BackgroundColor3 = VERMELHO
    removeBtn.Text = "Remover"
    removeBtn.TextColor3 = BRANCO
    removeBtn.Font = Enum.Font.GothamBold
    removeBtn.TextSize = 10
    removeBtn.BorderSizePixel = 0
    removeBtn.Parent = entry
    local rc = Instance.new("UICorner", removeBtn)
    rc.CornerRadius = UDim.new(0, 4)

    removeBtn.MouseButton1Click:Connect(function()
        if espUsers[target] then
            if espUsers[target].highlight then espUsers[target].highlight:Destroy() end
            if espUsers[target].conn then espUsers[target].conn:Disconnect() end
            espUsers[target] = nil
        end
        entry:Destroy()
    end)
end

local function removeESP(target)
    if espUsers[target] then
        if espUsers[target].highlight then espUsers[target].highlight:Destroy() end
        if espUsers[target].conn then espUsers[target].conn:Disconnect() end
        espUsers[target] = nil
    end
    local e = espListFrame:FindFirstChild(target.Name)
    if e then e:Destroy() end
end

task.spawn(function()
    while sg.Parent do
        task.wait(2)
        for p, data in pairs(espUsers) do
            if not p.Parent or (p.Character and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health <= 0) then
                removeESP(p)
            end
        end
    end
end)

local function clearResults()
    for _, v in pairs(resultsFrame:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
end

local function showUserResult(target)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 60)
    row.BackgroundColor3 = AZUL_ESCURO
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.Parent = resultsFrame
    local rc = Instance.new("UICorner", row)
    rc.CornerRadius = UDim.new(0, 6)
    local rs = Instance.new("UIStroke", row)
    rs.Color = AZUL

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.Position = UDim2.new(0, 5, 0, 5)
    avatar.BackgroundColor3 = AZUL_ESCURO
    avatar.BorderSizePixel = 0
    avatar.Parent = row
    local ac = Instance.new("UICorner", avatar)
    ac.CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        local ok, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and thumb then avatar.Image = thumb end
    end)

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -55, 0, 16)
    nameL.Position = UDim2.new(0, 50, 0, 3)
    nameL.BackgroundTransparency = 1
    nameL.Text = target.DisplayName .. " (@" .. target.Name .. ")"
    nameL.TextColor3 = BRANCO
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 11
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = row

    local question = Instance.new("TextLabel")
    question.Size = UDim2.new(1, -55, 0, 14)
    question.Position = UDim2.new(0, 50, 0, 20)
    question.BackgroundTransparency = 1
    question.Text = "Usar ESP?"
    question.TextColor3 = AZUL_CLARO
    question.Font = Enum.Font.Gotham
    question.TextSize = 10
    question.TextXAlignment = Enum.TextXAlignment.Left
    question.Parent = row

    local acceptBtn = Instance.new("TextButton")
    acceptBtn.Size = UDim2.new(0, 50, 0, 18)
    acceptBtn.Position = UDim2.new(0, 50, 0, 36)
    acceptBtn.BackgroundColor3 = VERDE
    acceptBtn.Text = "✓ Sim"
    acceptBtn.TextColor3 = BRANCO
    acceptBtn.Font = Enum.Font.GothamBold
    acceptBtn.TextSize = 10
    acceptBtn.BorderSizePixel = 0
    acceptBtn.Parent = row
    local apc = Instance.new("UICorner", acceptBtn)
    apc.CornerRadius = UDim.new(0, 4)

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 50, 0, 18)
    cancelBtn.Position = UDim2.new(0, 105, 0, 36)
    cancelBtn.BackgroundColor3 = VERMELHO
    cancelBtn.Text = "✗ Não"
    cancelBtn.TextColor3 = BRANCO
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 10
    cancelBtn.BorderSizePixel = 0
    cancelBtn.Parent = row
    local cbc = Instance.new("UICorner", cancelBtn)
    cbc.CornerRadius = UDim.new(0, 4)

    acceptBtn.MouseButton1Click:Connect(function()
        TweenService:Create(acceptBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {BackgroundColor3 = Color3.fromRGB(100, 255, 150)}):Play()
        addESP(target)
        clearResults()
    end)

    cancelBtn.MouseButton1Click:Connect(function()
        TweenService:Create(cancelBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {BackgroundColor3 = Color3.fromRGB(255, 150, 150)}):Play()
        task.wait(0.15)
        row:Destroy()
    end)
end

local function searchUser(query)
    clearResults()
    if query == "" then return end
    query = string.lower(query)

    local matches = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local dn = string.lower(p.DisplayName)
            local nn = string.lower(p.Name)
            if string.find(dn, query, 1, true) or string.find(nn, query, 1, true) then
                table.insert(matches, p)
            end
        end
    end

    if #matches == 0 then
        local noL = Instance.new("TextLabel")
        noL.Size = UDim2.new(1, 0, 0, 30)
        noL.BackgroundTransparency = 1
        noL.Text = "❌ Ninguém encontrado"
        noL.TextColor3 = VERMELHO
        noL.Font = Enum.Font.GothamBold
        noL.TextSize = 12
        noL.Parent = resultsFrame
        return
    end

    for i = 1, math.min(#matches, 2) do
        showUserResult(matches[i])
    end
end

espInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        searchUser(espInput.Text)
    end
end)

local attachPage = Instance.new("Frame")
attachPage.Size = UDim2.new(1, 0, 1, 0)
attachPage.BackgroundTransparency = 1
attachPage.Visible = false
attachPage.Parent = contentFrame

local attachTitle = Instance.new("TextLabel")
attachTitle.Size = UDim2.new(1, 0, 0, 22)
attachTitle.Position = UDim2.new(0, 0, 0, 2)
attachTitle.BackgroundTransparency = 1
attachTitle.Text = "🎯 Grudar / Girar"
attachTitle.TextColor3 = AZUL_CLARO
attachTitle.Font = Enum.Font.GothamBold
attachTitle.TextSize = 15
attachTitle.Parent = attachPage

local attachInput = Instance.new("TextBox")
attachInput.Size = UDim2.new(0, 200, 0, 24)
attachInput.Position = UDim2.new(0, 5, 0, 28)
attachInput.BackgroundColor3 = AZUL_ESCURO
attachInput.BackgroundTransparency = 0.2
attachInput.TextColor3 = BRANCO
attachInput.PlaceholderText = "Nome da pessoa..."
attachInput.PlaceholderColor3 = Color3.fromRGB(150, 180, 220)
attachInput.Text = ""
attachInput.TextSize = 12
attachInput.Font = Enum.Font.Gotham
attachInput.BorderSizePixel = 0
attachInput.ClearTextOnFocus = false
attachInput.Parent = attachPage
local aic = Instance.new("UICorner", attachInput)
aic.CornerRadius = UDim.new(0, 6)
local ais = Instance.new("UIStroke", attachInput)
ais.Color = AZUL
ais.Thickness = 1

local function makeActionBtn(txt, y, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 150, 0, 28)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = color or AZUL
    b.BackgroundTransparency = 0.15
    b.Text = txt
    b.TextColor3 = BRANCO
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.Parent = attachPage
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 6)
    return b
end

local girarBtn = makeActionBtn("🌀 Girar", 58, AZUL)
local grudarBtn = makeActionBtn("📌 Grudar", 90, AZUL)
local cancelAttachBtn = makeActionBtn("❌ Cancelar", 130, VERMELHO)
cancelAttachBtn.Visible = false

local attachStatus = Instance.new("TextLabel")
attachStatus.Size = UDim2.new(1, -10, 0, 20)
attachStatus.Position = UDim2.new(0, 5, 0, 165)
attachStatus.BackgroundTransparency = 1
attachStatus.Text = ""
attachStatus.TextColor3 = VERDE
attachStatus.Font = Enum.Font.GothamBold
attachStatus.TextSize = 12
attachStatus.TextXAlignment = Enum.TextXAlignment.Left
attachStatus.Parent = attachPage

local function findTarget(query)
    query = string.lower(query)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            if string.find(string.lower(p.Name), query, 1, true) or string.find(string.lower(p.DisplayName), query, 1, true) then
                return p
            end
        end
    end
    return nil
end

local function stopAttach()
    activeSpin = nil
    activeStick = nil
    cancelAttachBtn.Visible = false
    attachStatus.Text = ""
end

girarBtn.MouseButton1Click:Connect(function()
    local t = findTarget(attachInput.Text)
    if not t or not t.Character or not t.Character:FindFirstChild("HumanoidRootPart") then
        attachStatus.Text = "❌ Pessoa não encontrada!"
        attachStatus.TextColor3 = VERMELHO
        return
    end
    stopAttach()
    activeSpin = t
    cancelAttachBtn.Visible = true
    attachStatus.Text = "🌀 Girando em " .. t.Name
    attachStatus.TextColor3 = VERDE
end)

grudarBtn.MouseButton1Click:Connect(function()
    local t = findTarget(attachInput.Text)
    if not t or not t.Character or not t.Character:FindFirstChild("HumanoidRootPart") then
        attachStatus.Text = "❌ Pessoa não encontrada!"
        attachStatus.TextColor3 = VERMELHO
        return
    end
    stopAttach()
    activeStick = t
    cancelAttachBtn.Visible = true
    attachStatus.Text = "📌 Grudado em " .. t.Name
    attachStatus.TextColor3 = VERDE
end)

cancelAttachBtn.MouseButton1Click:Connect(function()
    local t = TweenService:Create(cancelAttachBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    t:Play()
    task.wait(0.15)
    TweenService:Create(cancelAttachBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
    stopAttach()
end)

local serverPage = Instance.new("Frame")
serverPage.Size = UDim2.new(1, 0, 1, 0)
serverPage.BackgroundTransparency = 1
serverPage.Visible = false
serverPage.Parent = contentFrame

local closeServerBtn = Instance.new("TextButton")
closeServerBtn.Size = UDim2.new(0, 24, 0, 24)
closeServerBtn.Position = UDim2.new(1, -28, 0, 0)
closeServerBtn.BackgroundColor3 = VERMELHO
closeServerBtn.Text = "X"
closeServerBtn.TextColor3 = BRANCO
closeServerBtn.Font = Enum.Font.GothamBlack
closeServerBtn.TextSize = 14
closeServerBtn.BorderSizePixel = 0
closeServerBtn.ZIndex = 10
closeServerBtn.Parent = serverPage
local csc = Instance.new("UICorner", closeServerBtn)
csc.CornerRadius = UDim.new(0, 6)

local serverList = Instance.new("ScrollingFrame")
serverList.Size = UDim2.new(1, -10, 1, -60)
serverList.Position = UDim2.new(0, 5, 0, 28)
serverList.BackgroundColor3 = AZUL_ESCURO
serverList.BackgroundTransparency = 0.4
serverList.BorderSizePixel = 0
serverList.ScrollBarThickness = 4
serverList.CanvasSize = UDim2.new(0, 0, 0, 0)
serverList.AutomaticCanvasSize = Enum.AutomaticSize.Y
serverList.Parent = serverPage
local slc = Instance.new("UICorner", serverList)
slc.CornerRadius = UDim.new(0, 8)
local sll = Instance.new("UIListLayout", serverList)
sll.Padding = UDim.new(0, 4)
sll.SortOrder = Enum.SortOrder.LayoutOrder
local slp = Instance.new("UIPadding", serverList)
slp.PaddingTop = UDim.new(0, 5)
slp.PaddingLeft = UDim.new(0, 5)
slp.PaddingRight = UDim.new(0, 5)

local function fetchServers()
    local servers = {}
    local ok, pages = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    if ok and pages then
        local decoded = HttpService:JSONDecode(pages)
        if decoded.data then
            for _, s in pairs(decoded.data) do
                if s.playing and s.maxPlayers and s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(servers, {id = s.id, playing = s.playing, max = s.maxPlayers, ping = s.ping or 0})
                end
            end
        end
    end
    return servers
end

local function refreshServerList()
    for _, v in pairs(serverList:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end

    task.spawn(function()
        local all = fetchServers()
        table.sort(all, function(a, b) return a.playing < b.playing end)

        local mostrar = {}
        for i = 1, math.min(20, #all) do
            table.insert(mostrar, all[i])
        end

        for i, s in pairs(mostrar) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -10, 0, 28)
            row.BackgroundColor3 = AZUL
            row.BackgroundTransparency = 0.6
            row.BorderSizePixel = 0
            row.Parent = serverList
            local rc = Instance.new("UICorner", row)
            rc.CornerRadius = UDim.new(0, 6)

            local infoL = Instance.new("TextLabel")
            infoL.Size = UDim2.new(0.6, 0, 1, 0)
            infoL.Position = UDim2.new(0, 5, 0, 0)
            infoL.BackgroundTransparency = 1
            infoL.Text = "🌎 " .. s.playing .. "/" .. s.max .. " | " .. s.id:sub(1, 8)
            infoL.TextColor3 = BRANCO
            infoL.Font = Enum.Font.Gotham
            infoL.TextSize = 11
            infoL.TextXAlignment = Enum.TextXAlignment.Left
            infoL.Parent = row

            local joinBtn = Instance.new("TextButton")
            joinBtn.Size = UDim2.new(0, 60, 0, 22)
            joinBtn.Position = UDim2.new(1, -65, 0, 3)
            joinBtn.BackgroundColor3 = VERDE
            joinBtn.Text = "Entrar"
            joinBtn.TextColor3 = BRANCO
            joinBtn.Font = Enum.Font.GothamBold
            joinBtn.TextSize = 11
            joinBtn.BorderSizePixel = 0
            joinBtn.Parent = row
            local jc = Instance.new("UICorner", joinBtn)
            jc.CornerRadius = UDim.new(0, 5)

            joinBtn.MouseButton1Click:Connect(function()
                TweenService:Create(joinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 255, 150)}):Play()
                task.wait(0.15)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
            end)
        end
    end)
end

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 80, 0, 20)
refreshBtn.Position = UDim2.new(0, 5, 0, 3)
refreshBtn.BackgroundColor3 = AZUL
refreshBtn.Text = "🔄 Atualizar"
refreshBtn.TextColor3 = BRANCO
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 11
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = serverPage
local rbc = Instance.new("UICorner", refreshBtn)
rbc.CornerRadius = UDim.new(0, 5)
refreshBtn.MouseButton1Click:Connect(function()
    refreshServerList()
end)

task.spawn(function()
    while sg.Parent do
        if serverPage.Visible then
            refreshServerList()
        end
        task.wait(5)
    end
end)

local function switchTab(tab)
    currentTab = tab
    mainPage.Visible = (tab == "main")
    espPage.Visible = (tab == "esp")
    attachPage.Visible = (tab == "attach")
    serverPage.Visible = (tab == "server")

    tabMain.BackgroundColor3 = (tab == "main") and AZUL or AZUL_ESCURO
    tabESP.BackgroundColor3 = (tab == "esp") and AZUL or AZUL_ESCURO
    tabAttach.BackgroundColor3 = (tab == "attach") and AZUL or AZUL_ESCURO
    tabServer.BackgroundColor3 = (tab == "server") and AZUL or AZUL_ESCURO

    local target = mainPage
    if tab == "esp" then target = espPage end
    if tab == "attach" then target = attachPage end
    if tab == "server" then target = serverPage end

    if target then
        for _, c in pairs(target:GetDescendants()) do
            if c:IsA("GuiObject") and c.BackgroundTransparency < 1 then
                local orig = c.BackgroundTransparency
                c.BackgroundTransparency = 1
                TweenService:Create(c, TweenInfo.new(0.25), {BackgroundTransparency = orig}):Play()
            end
        end
    end
end

tabMain.MouseButton1Click:Connect(function() switchTab("main") end)
tabESP.MouseButton1Click:Connect(function() switchTab("esp") end)
tabAttach.MouseButton1Click:Connect(function() switchTab("attach") end)
tabServer.MouseButton1Click:Connect(function() switchTab("server") end)

closeEspBtn.MouseButton1Click:Connect(function() switchTab("main") end)
closeServerBtn.MouseButton1Click:Connect(function() switchTab("main") end)

minBtn.MouseButton1Click:Connect(function()
    local t = TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.4, 0)
    })
    t:Play()
    t.Completed:Wait()
    frame.Visible = false
    frame.Size = UDim2.new(0, 380, 0, 300)
    frame.Position = UDim2.new(0.5, -190, 0.35, -150)

    abrirBtn.Visible = true
    abrirBtn.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(abrirBtn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 70, 0, 30)
    }):Play()
end)

abrirBtn.MouseButton1Click:Connect(function()
    TweenService:Create(abrirBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.15)
    abrirBtn.Visible = false
    abrirBtn.Size = UDim2.new(0, 70, 0, 30)

    frame.Visible = true
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.4, 0)
    local t = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 300),
        Position = UDim2.new(0.5, -190, 0.35, -150)
    })
    t:Play()
end)

lockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    lockBtn.Text = locked and "🔒" or "🔓"
    lockBtn.BackgroundColor3 = locked and Color3.fromRGB(200, 150, 0) or AZUL

    if locked then
        dragging = false
    end

    TweenService:Create(lockBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size = UDim2.new(0, 30, 0, 26)}):Play()
    task.wait(0.15)
    TweenService:Create(lockBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size = UDim2.new(0, 26, 0, 22)}):Play()
end)

local creditos = Instance.new("TextLabel")
creditos.Size = UDim2.new(1, 0, 0, 14)
creditos.Position = UDim2.new(0, 0, 1, 2)
creditos.BackgroundTransparency = 1
creditos.Text = "By DraxiLow"
creditos.TextColor3 = AZUL_CLARO
creditos.Font = Enum.Font.GothamBold
creditos.TextSize = 11
creditos.Parent = frame

RunService.Stepped:Connect(function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            if currentSpeed > 1 and hum.MoveDirection.Magnitude > 0 then
                local spd = speedValues[currentSpeed]
                local vel = hum.MoveDirection * spd
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X, hrp.AssemblyLinearVelocity.Y, vel.Z)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if activeSpin then
        local target = activeSpin
        if not target.Parent or not target.Character then stopAttach(); return end
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then stopAttach(); return end

        local myChar = player.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if not myHrp or not myHum then return end

        local angle = tick() * 3
        local offset = Vector3.new(math.cos(angle) * 6, 0, math.sin(angle) * 6)
        local targetPos = hrp.Position + offset

        local lookDir = (hrp.Position - targetPos).Unit
        myHrp.CFrame = CFrame.new(targetPos, targetPos + lookDir)
        myHrp.AssemblyLinearVelocity = Vector3.new(0, myHrp.AssemblyLinearVelocity.Y, 0)

    elseif activeStick then
        local target = activeStick
        if not target.Parent or not target.Character then stopAttach(); return end
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then stopAttach(); return end

        local myChar = player.Character
        if not myChar then return end
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if not myHrp or not myHum then return end

        local targetLook = hrp.CFrame.LookVector
        local behind = hrp.Position - targetLook * 4

        local lookDir = (hrp.Position - behind).Unit
        myHrp.CFrame = CFrame.new(behind, behind + lookDir)
        myHrp.AssemblyLinearVelocity = Vector3.new(0, myHrp.AssemblyLinearVelocity.Y, 0)
    end
end)

frame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 380, 0, 300)
}):Play()