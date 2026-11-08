local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
local Window = OrionLib:MakeWindow({Name = "Opah Ultra Menu - Delta", HidePremium = false, SaveConfig = true, ConfigFolder = "OpahConfig"})

-- Fungsi Global Visual ESP Highlight
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
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = object
        billboard.Parent = object

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = color
        label.TextSize = 16
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
    end
end

-- Fungsi Menghapus ESP
local function removeESP(object)
    if object:FindFirstChild("ESPHighlight") then object.ESPHighlight:Destroy() end
    if object:FindFirstChild("ESPText") then object.ESPText:Destroy() end
end

-- Fungsi Teleportasi Aman
local function teleportTo(object)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if object:IsA("Model") and object.PrimaryPart then
            player.Character.HumanoidRootPart.CFrame = object.PrimaryPart.CFrame + Vector3.new(0, 2, 0)
        elseif object:IsA("Part") or object:IsA("MeshPart") then
            player.Character.HumanoidRootPart.CFrame = object.CFrame + Vector3.new(0, 2, 0)
        end
    end
end

-- ========================================================
-- TAB AUTOMATION (AUTO-ESCAPE & CODE READER)
-- ========================================================
local AutoTab = Window:MakeTab({Name = "Auto Escape", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local CodeLabel = AutoTab:AddLabel("Membaca Kode Pintu: Menunggu Kertas Muncul...")

-- Loop otomatis mendeteksi kertas kode dari Dex Explorer
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            local note = workspace:FindFirstChild("PasscodeNote")
            if note and note:FindFirstChild("Paper") and note.Paper:FindFirstChild("Writing") and note.Paper.Writing:FindFirstChild("Code") then
                local currentCode = note.Paper.Writing.Code.Text
                if currentCode and currentCode ~= "" then
                    CodeLabel:Set("Kode Pintu Terdeteksi: " .. tostring(currentCode))
                end
            else
                CodeLabel:Set("Membaca Kode Pintu: Kertas belum di-spawn/diambil")
            end
         pcall(function()
            -- Auto-Collect Kunci jika berada dalam jangkauan dekat secara instan
            if _G.AutoCollectKeys and workspace:FindFirstChild("PuzzleItems") then
                for _, key in pairs(workspace.PuzzleItems:GetChildren()) do
                    if key:FindFirstChild("PuzzleClick") then
                        local player = game.Players.LocalPlayer
                        local dist = (player.Character.HumanoidRootPart.Position - key.Position).Magnitude
                        if dist < 15 then
                            fireclickdetector(key.PuzzleClick)
                        end
                    end
                end
            end
         end)
        end)
    end
end)

AutoTab:AddToggle({
    Name = "Auto Ambil Kunci Terdekat (Radius Dekat)",
    Default = false,
    Callback = function(Value)
        _G.AutoCollectKeys = Value
    end
})

AutoTab:AddButton({
    Name = "Instant Escape TP Loop (Kunci -> Gembok)",
    Callback = function()
        OrionLib:MakeNotification({Name = "Sistem Escape", Content = "Memulai rute membuka kunci otomatis...", Time = 3})
        
        -- Ambil Kunci di PuzzleItems jika ada
        if workspace:FindFirstChild("PuzzleItems") and #workspace.PuzzleItems:GetChildren() > 0 then
            for _, key in pairs(workspace.PuzzleItems:GetChildren()) do
                teleportTo(key)
                task.wait(0.5)
                if key:FindFirstChild("PuzzleClick") then fireclickdetector(key.PuzzleClick) end
                task.wait(0.3)
                
                -- Cari gembok di PuzzleLocks yang belum terbuka untuk dipasangkan
                if workspace:FindFirstChild("PuzzleLocks") then
                    for _, lock in pairs(workspace.PuzzleLocks:GetChildren()) do
                        if lock:FindFirstChild("PuzzleClick") then
                            teleportTo(lock)
                            task.wait(0.5)
                            fireclickdetector(lock.PuzzleClick)
                            task.wait(0.5)
                            break
                        end
                    end
                end
            end
        else
            -- Jika kunci habis, langsung arahkan ke pintu utama / Keypad
            local keypad = workspace:FindFirstChild("Keypad")
            if keypad then 
                teleportTo(keypad) 
                OrionLib:MakeNotification({Name = "Escape", Content = "Silakan masukkan kode pintu di atas!", Time = 5})
            end
        end
    end
})

-- ========================================================
-- TAB VISUAL ESP
-- ========================================================
local ESPTab = Window:MakeTab({Name = "Visual ESP", Icon = "rbxassetid://4483345998", PremiumOnly = false})

ESPTab:AddToggle({
    Name = "ESP Opah / Nenek",
    Default = false,
    Callback = function(Value)
        _G.OpahESP = Value
        while _G.OpahESP do
            task.wait(1)
            if workspace:FindFirstChild("OpahRuntime") then
                for _, v in pairs(workspace.OpahRuntime:GetChildren()) do
                    if v:IsA("Model") then createESP(v, Color3.fromRGB(255, 0, 0), "⚠️ OPAH ⚠️") end
                end
            end
        end
        if not Value and workspace:FindFirstChild("OpahRuntime") then
            for _, v in pairs(workspace.OpahRuntime:GetChildren()) do removeESP(v) end
        end
    end    
})

ESPTab:AddToggle({
    Name = "ESP Kunci (Puzzle Items)",
    Default = false,
    Callback = function(Value)
        _G.KeyESP = Value
        while _G.KeyESP do
            task.wait(1)
            if workspace:FindFirstChild("PuzzleItems") then
                for _, v in pairs(workspace.PuzzleItems:GetChildren()) do
                    createESP(v, Color3.fromRGB(255, 255, 0), "🔑 Kunci")
                end
            end
        end
        if not Value and workspace:FindFirstChild("PuzzleItems") then
            for _, v in pairs(workspace.PuzzleItems:GetChildren()) do removeESP(v) end
        end
    end    
})

ESPTab:AddToggle({
    Name = "ESP Kertas Kode (Passcode)",
    Default = false,
    Callback = function(Value)
        _G.NoteESP = Value
        while _G.NoteESP do
            task.wait(1)
            local note = workspace:FindFirstChild("PasscodeNote")
            if note then createESP(note, Color3.fromRGB(0, 255, 255), "📄 Catatan Kode") end
        end
        if not Value and workspace:FindFirstChild("PasscodeNote") then removeESP(workspace.PasscodeNote) end
    end    
})

ESPTab:AddToggle({
    Name = "ESP Gembok & Keypad",
    Default = false,
    Callback = function(Value)
        _G.LockESP = Value
        while _G.LockESP do
            task.wait(1)
            if workspace:FindFirstChild("PuzzleLocks") then
                for _, v in pairs(workspace.PuzzleLocks:GetChildren()) do createESP(v, Color3.fromRGB(255, 0, 255), "🔒 " .. v.Name) end
            end
            if workspace:FindFirstChild("Keypad") then createESP(workspace.Keypad, Color3.fromRGB(255, 128, 0), "🔢 Keypad Pintu") end
        end
        if not Value then
            if workspace:FindFirstChild("PuzzleLocks") then for _, v in pairs(workspace.PuzzleLocks:GetChildren()) do removeESP(v) end end
            if workspace:FindFirstChild("Keypad") then removeESP(workspace.Keypad) end
        end
    end    
})

-- ========================================================
-- TAB TELEPORTASI
-- ========================================================
local TPTab = Window:MakeTab({Name = "Teleportasi", Icon = "rbxassetid://4483345998", PremiumOnly = false})

TPTab:AddButton({
    Name = "TP ke Kertas Kode (Passcode)",
    Callback = function()
        local note = workspace:FindFirstChild("PasscodeNote")
        if note then teleportTo(note) else OrionLib:MakeNotification({Name = "Error", Content = "Kertas belum muncul!", Time = 3}) end
    end
})

TPTab:AddButton({
    Name = "TP ke Kunci Terdekat (Key)",
    Callback = function()
        if workspace:FindFirstChild("PuzzleItems") and #workspace.PuzzleItems:GetChildren() > 0 then
            teleportTo(workspace.PuzzleItems:GetChildren()[1])
        else
            OrionLib:MakeNotification({Name = "Error", Content = "Tidak ada kunci di map!", Time = 3})
        end
    end
})

TPTab:AddButton({
    Name = "TP ke Keypad Utama",
    Callback = function()
        local keypad = workspace:FindFirstChild("Keypad")
        if keypad then teleportTo(keypad) else OrionLib:MakeNotification({Name = "Error", Content = "Keypad tidak ditemukan!", Time = 3}) end
    end
})

OrionLib:Init()
