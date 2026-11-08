-- ========================================================
-- SCRIPT BY AI COLLABORATOR - BERMALAM BERSAMA OPAH + AUTO DRAWERS
-- ========================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer

-- Fungsi Global Pembuat ESP Highlight
local function createESP(object, color, name)
    if not object:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = color
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = object
        highlight.Parent = object

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPText"
        billboard.Size = UDim2.new(0, 150, 0, 30)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = object
        billboard.Parent = object

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = color
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0
        label.Parent = billboard
    end
end

-- Fungsi Menghapus ESP
local function removeESP(object)
    if object:FindFirstChild("ESPHighlight") then object.ESPHighlight:Destroy() end
    if object:FindFirstChild("ESPText") then object.ESPText:Destroy() end
end

-- Fungsi Teleportasi Aman ke Objek
local function teleportTo(object)
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCFrame
        if object:IsA("Model") then
            if object.PrimaryPart then
                targetCFrame = object.PrimaryPart.CFrame
            else
                local part = object:FindFirstChildWhichIsA("BasePart")
                if part then targetCFrame = part.CFrame end
            end
        elseif object:IsA("BasePart") then
            targetCFrame = object.CFrame
        end

        if targetCFrame then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 3, 0)
        end
    end
end

-- ========================================================
-- MEMBUAT LITE FLOATING GUI (MENGAMBANG & BISA DIGESER)
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OpahUltraLite"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 355) -- Ukuran diperbesar sedikit untuk tombol baru
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Text = "OPAH ULTRA LITE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 45)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = MainFrame

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    btn.Parent = MainFrame
    return btn
end

-- ========================================================
-- SISTEM AKTIVASI FITUR SAKELAR (TOGGLE) & ACTION
-- ========================================================
local opahESPActive = false
local keyESPActive = false
local codeESPActive = false

-- 1. Toggle ESP Opah / Nenek
local OpahBtn = createButton("Toggle ESP Opah: OFF", function()
    opahESPActive = not opahESPActive
    if opahESPActive then
        OpahBtn.Text = "Toggle ESP Opah: ON"
        OpahBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        OpahBtn.Text = "Toggle ESP Opah: OFF"
        OpahBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        if Workspace:FindFirstChild("OpahRuntime") then
            for _, v in pairs(Workspace.OpahRuntime:GetChildren()) do removeESP(v) end
        end
    end
end)

-- 2. Toggle ESP Kunci (PuzzleItems)
local KeyBtn = createButton("Toggle ESP Kunci: OFF", function()
    keyESPActive = not keyESPActive
    if keyESPActive then
        KeyBtn.Text = "Toggle ESP Kunci: ON"
        KeyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        KeyBtn.Text = "Toggle ESP Kunci: OFF"
        KeyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        if Workspace:FindFirstChild("PuzzleItems") then
            for _, v in pairs(Workspace.PuzzleItems:GetChildren()) do removeESP(v) end
        end
    end
end)

-- 3. Toggle ESP Kertas Kode (PasscodeNote)
local CodeBtn = createButton("Toggle ESP Kertas Kode: OFF", function()
    codeESPActive = not codeESPActive
    if codeESPActive then
        CodeBtn.Text = "Toggle ESP Kertas Kode: ON"
        CodeBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 150)
    else
        CodeBtn.Text = "Toggle ESP Kertas Kode: OFF"
        CodeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        if Workspace:FindFirstChild("PasscodeNote") then removeESP(Workspace.PasscodeNote) end
    end
end)

-- 4. BARU: Tombol Auto Buka Semua Laci (Chest / Drawers) Sekaligus
createButton("🔓 Auto Buka Semua Laci", function()
    local openedCount = 0
    -- Mencari semua folder berawalan TripleChest atau DoubleChest di Workspace
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:match("Chest") or obj.Name:match("TripleChest") or obj.Name:match("DoubleChest") then
            -- Memicu ProximityPrompt bawaan game untuk membuka laci dari jauh
            for _, descendant in pairs(obj:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    fireproximityprompt(descendant)
                    openedCount = openedCount + 1
                end
            end
        end
    end
    -- Jika menggunakan ClickDetector di lacinya, skrip alternatif ini ikut memicu:
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:match("Chest") then
            for _, descendant in pairs(obj:GetDescendants()) do
                if descendant:IsA("ClickDetector") then
                    fireclickdetector(descendant)
                end
            end
        end
    end
end)

-- 5. Tombol Teleportasi ke Kunci Terdekat
createButton("✨ TP ke Kunci Terdekat", function()
    if Workspace:FindFirstChild("PuzzleItems") and #Workspace.PuzzleItems:GetChildren() > 0 then
        local keyList = Workspace.PuzzleItems:GetChildren()
        teleportTo(keyList[1])
    end
end)

-- 6. Tombol Teleportasi ke Kertas Kode
createButton("📄 TP ke Kertas Kode", function()
    local note = Workspace:FindFirstChild("PasscodeNote")
    if note then
        teleportTo(note)
    end
end)

-- 7. Tombol Teleportasi ke Keypad Utama (Pintu Keluar)
createButton("🔢 TP ke Keypad Pintu Utama", function()
    local keypad = Workspace:FindFirstChild("Keypad")
    if keypad then
        teleportTo(keypad)
    end
end)

-- ========================================================
-- UTILITY LOOP ENGINE (BERJALAN DI LATAR BELAKANG)
-- ========================================================
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            -- Loop ESP Opah
            if opahESPActive and Workspace:FindFirstChild("OpahRuntime") then
                for _, v in pairs(Workspace.OpahRuntime:GetChildren()) do
                    if v:IsA("Model") then createESP(v, Color3.fromRGB(255, 0, 0), "⚠️ OPAH ⚠️") end
                end
            end

            -- Loop ESP Kunci
            if keyESPActive and Workspace:FindFirstChild("PuzzleItems") then
                for _, v in pairs(Workspace.PuzzleItems:GetChildren()) do
                    createESP(v, Color3.fromRGB(255, 255, 0), "🔑 Kunci")
                end
            end

            -- Loop ESP Catatan Kode
            if codeESPActive then
                local note = Workspace:FindFirstChild("PasscodeNote")
                if note then createESP(note, Color3.fromRGB(0, 255, 255), "📄 Catatan Kode") end
            end
        end)
    end
end)
