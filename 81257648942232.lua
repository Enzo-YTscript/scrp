-- Memuat library Rayfield dengan error handling
local Rayfield
local success, errorMsg = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Gagal memuat Rayfield library: " .. tostring(errorMsg))
    return
end

-- Mendapatkan nama game secara otomatis
local gameName = "Game Script" -- fallback jika gagal ambil nama
pcall(function()
    gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

-- Membuat jendela utama
local Window = Rayfield:CreateWindow({
    Name = gameName,
    Icon = 0,
    LoadingTitle = gameName,
    LoadingSubtitle = "by ENZO-YT",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false -- Nonaktifkan penyimpanan untuk script sederhana ini
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink"
    },
    KeySystem = false
})

-- Tab utama
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Combat & Auto")

-- Variabel untuk Auto Kill Mob
local AutoKillMobEnabled = false
local autoKillMobThread = nil

-- Toggle Auto Kill Mob
local AutoKillMobToggle = MainTab:CreateToggle({
    Name = "Auto Kill Mob",
    CurrentValue = false,
    Flag = "AutoKillMobToggle",
    Callback = function(Value)
        AutoKillMobEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Kill Mob Enabled",
                Content = "Scanning and attacking nearby mobs...",
                Duration = 5
            })
            autoKillMobThread = spawn(function()
                while AutoKillMobEnabled do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character then
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            -- Cari semua mob dalam radius (misal 50 studs)
                            local radius = 200
                            for _, room in pairs(workspace:GetChildren()) do
                                if room:IsA("Folder") and room.Name:match("Room") then
                                    for _, subRoom in pairs(room:GetChildren()) do
                                        if subRoom:IsA("Folder") and subRoom.Name:match("Room") then
                                            local mobFolder = subRoom:FindFirstChild("Mob")
                                            if mobFolder then
                                                for _, mob in pairs(mobFolder:GetChildren()) do
                                                    if mob:IsA("Model") and mob:FindFirstChild("Humanoid") then
                                                        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                                                        if mobRoot and (mobRoot.Position - rootPart.Position).Magnitude <= radius then
                                                            local args = {
                                                                mob:FindFirstChild("Humanoid")
                                                            }
                                                            local success, err = pcall(function()
                                                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Event"):WaitForChild("Fight"):WaitForChild("[C-S]TakeDamage"):FireServer(unpack(args))
                                                            end)
                                                            if not success then
                                                                -- Opsional: log error jika butuh
                                                                -- warn("Failed to damage mob: " .. err)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    wait(0.1) -- Interval serangan
                end
            end)
        else
            if autoKillMobThread then
                coroutine.close(autoKillMobThread)
                autoKillMobThread = nil
            end
            Rayfield:Notify({
                Title = "Auto Kill Mob Disabled",
                Content = "Stopped attacking mobs.",
                Duration = 5
            })
        end
    end
})

-- Fungsi untuk mengambil level dari UI
local function getCurrentLevel()
    local player = game.Players.LocalPlayer
    local uiPath = player.PlayerGui:FindFirstChild("Main")
        and player.PlayerGui.Main:FindFirstChild("Up")
        and player.PlayerGui.Main.Up:FindFirstChild("Info")
        and player.PlayerGui.Main.Up.Info:FindFirstChild("Stats")
        and player.PlayerGui.Main.Up.Info.Stats:FindFirstChild("regen")
        and player.PlayerGui.Main.Up.Info.Stats.regen:FindFirstChild("Info")
        and player.PlayerGui.Main.Up.Info.Stats.regen.Info:FindFirstChild("Info")

    if uiPath and uiPath:IsA("TextLabel") then
        local text = uiPath.Text
        local level = text:match("Lv%. (%d+)")
        return tonumber(level) or 1
    else
        return 1 -- fallback
    end
end

-- Variabel untuk Auto Regen
local AutoRegenEnabled = false
local autoRegenThread = nil

-- Toggle Auto Regen (Level-based)
local AutoRegenToggle = MainTab:CreateToggle({
    Name = "Auto Regen (Lv-Based)",
    CurrentValue = false,
    Flag = "AutoRegenToggle",
    Callback = function(Value)
        AutoRegenEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Regen Enabled",
                Content = "Auto regenerating health using current level from UI...",
                Duration = 5
            })
            autoRegenThread = spawn(function()
                while AutoRegenEnabled do
                    local level = getCurrentLevel()
                    local args = { level }

                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage").Remote.Event.Up["[C-S]TryRegen"]:FireServer(unpack(args))
                    end)

                    if not success then
                        Rayfield:Notify({
                            Title = "Auto Regen Error",
                            Content = "Failed to regen: " .. tostring(err),
                            Duration = 5
                        })
                        AutoRegenEnabled = false
                        AutoRegenToggle:Set(false)
                        break
                    end

                    wait(0.01) -- Interval sangat cepat
                end
            end)
        else
            if autoRegenThread then
                coroutine.close(autoRegenThread)
                autoRegenThread = nil
            end
            Rayfield:Notify({
                Title = "Auto Regen Disabled",
                Content = "Regeneration stopped.",
                Duration = 5
            })
        end
    end
})

-- Variabel untuk Auto Get Exp
local AutoGetExpEnabled = false
local autoGetExpThread = nil

-- Toggle Auto Get Exp
local AutoGetExpToggle = MainTab:CreateToggle({
    Name = "Auto Get Exp",
    CurrentValue = false,
    Flag = "AutoGetExpToggle",
    Callback = function(Value)
        AutoGetExpEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Get Exp Enabled",
                Content = "Collecting EXP automatically every 0.1s...",
                Duration = 5
            })
            autoGetExpThread = spawn(function()
                while AutoGetExpEnabled do
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage").Remote.Event.Fight["[C-S]TakeExp"]:FireServer()
                    end)

                    if not success then
                        Rayfield:Notify({
                            Title = "Auto Get Exp Error",
                            Content = "Failed to get EXP: " .. tostring(err),
                            Duration = 5
                        })
                        AutoGetExpEnabled = false
                        AutoGetExpToggle:Set(false)
                        break
                    end

                    wait(0.01) -- Interval
                end
            end)
        else
            if autoGetExpThread then
                coroutine.close(autoGetExpThread)
                autoGetExpThread = nil
            end
            Rayfield:Notify({
                Title = "Auto Get Exp Disabled",
                Content = "EXP collection stopped.",
                Duration = 5
            })
        end
    end
})

-- Info Label
MainTab:CreateLabel({
    Name = "By ENZO-YT"
})

-- Notifikasi saat script selesai load
Rayfield:Notify({
    Title = "Script Loaded",
    Content = gameName .. " script has been loaded successfully!",
    Duration = 5
})