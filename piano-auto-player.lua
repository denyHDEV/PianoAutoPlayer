--[[
    Roblox Universal Virtual Piano Auto-Player
    Motor: V3 Bulletproof (Sync Optimizat cu Suport Liniuțe)
    Viteză: BPM 200
    Piesă: Noua Partitură Solicitată
--]]

local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

-- Compatibilitate Xeno / Executoare moderne
local targetGui = (gethui and gethui()) or CoreGui

local isPlaying = false
local bpm = 170 
local delaySec = 60 / bpm

-- ==================== MOTOR EXECUTIE ====================
local KeyMap = {
    ["0"] = Enum.KeyCode.Zero, ["1"] = Enum.KeyCode.One, ["2"] = Enum.KeyCode.Two, ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four, ["5"] = Enum.KeyCode.Five, ["6"] = Enum.KeyCode.Six, ["7"] = Enum.KeyCode.Seven,
    ["8"] = Enum.KeyCode.Eight, ["9"] = Enum.KeyCode.Nine,
    ["!"] = Enum.KeyCode.One, ["@"] = Enum.KeyCode.Two, ["#"] = Enum.KeyCode.Three, ["$"] = Enum.KeyCode.Four,
    ["%"] = Enum.KeyCode.Five, ["^"] = Enum.KeyCode.Six, ["&"] = Enum.KeyCode.Seven, ["*"] = Enum.KeyCode.Eight,
    ["("] = Enum.KeyCode.Nine, [")"] = Enum.KeyCode.Zero,
    ["["] = Enum.KeyCode.LeftBracket, ["{"] = Enum.KeyCode.LeftBracket,
    ["]"] = Enum.KeyCode.RightBracket, ["}"] = Enum.KeyCode.RightBracket,
    ["\\"] = Enum.KeyCode.BackSlash, ["|"] = Enum.KeyCode.BackSlash,
    [";"] = Enum.KeyCode.Semicolon, [":"] = Enum.KeyCode.Semicolon,
    ["'"] = Enum.KeyCode.Quote, ['"'] = Enum.KeyCode.Quote,
    [","] = Enum.KeyCode.Comma, ["<"] = Enum.KeyCode.Comma,
    ["."] = Enum.KeyCode.Period, [">"] = Enum.KeyCode.Period,
    ["/"] = Enum.KeyCode.Slash, ["?"] = Enum.KeyCode.Slash
}

local function getKeyCode(char)
    if char:match("%a") then return Enum.KeyCode[char:upper()] end
    return KeyMap[char]
end

local function requiresShift(char)
    if char:match("%u") then return true end
    local shiftChars = "!@#$%^&*()_+{}|:\"<>?"
    return shiftChars:find(char, 1, true) ~= nil
end

local function hitNotes(charsTable)
    local needsShift = false
    for _, char in ipairs(charsTable) do
        if requiresShift(char) then needsShift = true break end
    end

    if needsShift then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
    end

    for _, char in ipairs(charsTable) do
        local kc = getKeyCode(char)
        if kc then VirtualInputManager:SendKeyEvent(true, kc, false, game) end
    end
    
    task.wait(0.015)

    for _, char in ipairs(charsTable) do
        local kc = getKeyCode(char)
        if kc then VirtualInputManager:SendKeyEvent(false, kc, false, game) end
    end

    if needsShift then
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
    end
end

-- ==================== PARTITURA NOUĂ ====================
local sheetMusic = [[
6 - [etu] - [etu] -
3 - [0wr] - [0wr] -
4 - [qet] - [qet] -
5 - [wry] - [wry] -
6 - [etu] - [etu] -
3 - [0wr] - [0wr] -
4 - [qet] - [qet] -
5 - [wry] - [wry] -
[6fx] - [etu] - [etu] -
[3dz] - [0wr] - [0wr] -
[4pj] - [qet] - [qet] -
[5pj] [ak] [wrysl] - [wryak] -
[6pj] - [etu] - [etu] -
[3oh] - [0wr] [uf] [0wroh] [ak]
[4pj] - [qet] - [qet] -
5 - [wry] - [wry] -
[6fx] - [etu] - [etu] -
[3dz] - [0wr] - [0wr] -
[4pj] - [qet] - [qet] -
[5pj] [ak] [wrysl] - [wryak] -
[6pj] - [etu] - [etu] -
[3oh] - [0wr] - [0wr] -
[4pj] - [qet] - [qet] -
[5ak] - [wry] - [wry] -
[6sl] [sl] [etusl] - [etusl] -
[3dz] - [0wr] - [0wr] -
[4sl] [ak] [qetsl] - [qetak] -
[5pj] - [wry] - [wry] -
[6sl] [sl] [etusl] - [etusl] -
[3dz] - [0wr] - [0wr] -
[4sl] [sl] [qetsl] - [qetpj] -
[5sl] - [wry] - [wry] -
[6sl] [sl] [etusl] - [etusl] -
[3dz] - [0wr] - [0wrak] -
4 - [qetsl] [ak] [qetsl] [ak]
[5pj] - [wry] - [wryoh] -
[6pj] - [etu] - [etu] -
3 - [0wr] - [0wr] -
4 - [qet] - [qet] -
5 - [wry] - [wry] -
[6fx] - [etup] a [etus] p
[3dz] - [0wro] p [0wra] s
[4pj] - [qet] - [qet] -
[5pj] [ak] [wrysl] - [wryak] -
[6pj] - [etuf] j [etul] x
[3oh] - [0wr] f [0wrh] k
[4pj] - [qet] - [qet] -
5 - [wrypj] - [wrypj] -
[6fx] - [etu] c [etux] z
[3sl] - [0wr] z [0wrl] k
[4pj] - [qet] - [qet] -
[5pj] [ak] [wrysl] - [wryak] [pj]
[6oh] - [etu] - [etu] -
3 - [0wr] - [0wruf] -
[4pj] - [qetu] o [qetp] s
[5ak], [wrysl], [wrydz],
[6sl] [sl] [etusl] - [etusl] -
[3dz] - [0wr] - [0wr] -
[4sl] [ak] [qetsl] - [qetak] -
[5pj] - [wry] - [wry] -
[6sl] [sl] [etusl] - [etusl] -
[3dz] - [0wr] - [0wr] -
[4sl] [sl] [qetsl] - [qetpj] -
[5sl] - [wry] - [wryak] -
[6sl] - [etusl] [sl] [etusl] -
[3dz] - [0wr] - [0wruiopak] -
4 - [qetsl] [ak] [qetsl] [ak]
[5p] - [wry] - [wryoh] -
[6pj] - [etu] - [etu] -
3 - [0wr] - [0wr] -
4 - [qetuf] - [qetoh] -
[5ak] - [wrypj] - [wry] [oh]
[6euf] - [etu] - [etu] -
[83] - [0wr] - [0wr] -
[94] - [qetfx] - [qethv] -
[5qkn] - [wryjb] - [wry] [hv]
[6ebx] - [etu] - [etu] -
[83] - [0wr] - [0wr] -
[94] - [qetuf] - [qetoh] -
[5qak] - [wrypj] - [wry] [oh]
[6efx] - [etu] - [etu] -
[3dz] - [0wr] - [0wr] -
[4pj] - [qet] - [qet] [pj]
[5pj] - [wryoh] - [wry] [oh]
[6pj] - [etu] - [etu] -
3 - [0wr] - [0wr] -
4 - [qet] - [qet] -
5 - [wry] - [wry] -
[6s]-[0f]-j-x...
[3u]-[7p]-[wd]...
[4r]-[8u]-[ep]...
[59wp] a s - a -
[6t]-[0u]-p-f...
[3u]-[7p]-[wd], u o a
[4r]-[8u]-[ep]...
[48e] - [pfj] [48e] [pfj] -
[6efx] - [etu] - [etu] -
[3dz] - [0wr] - [0wr] -
[4pj] - [qet] - [qet] -
[5pj] [ak] [wrysl] - [wryak] -
[6pj] - [etufx] - [etupj] -
[3ak] - [0wrfx] - [0wrak] -
[4sl] - [qetfx] - [qetsl] -
[5dz] - [wrysl] [dz] [wrysl] [ak]
[6epj] - [etufx] - [etupj] -
[83ak] - [0wrfx] - [0wrak] -
[94sl] - [qetfx] - [qetsl] -
[5qdz] - [wrysl] [dz] [wrysl] [ak]
[pj]
]]

local function playSheet(sheetText)
    isPlaying = true
    local i = 1
    local length = #sheetText

    while i <= length and isPlaying do
        local char = sheetText:sub(i, i)
        
        if char == "[" then
            local chord = {}
            i = i + 1
            while i <= length and sheetText:sub(i, i) ~= "]" do
                local c = sheetText:sub(i, i)
                if c:match("%S") then table.insert(chord, c) end
                i = i + 1
            end
            if #chord > 0 then hitNotes(chord) end
            
        elseif char:match("[%a%d!@#$%%^&*()_%+={}\\|;:'\"<>/]") then
            hitNotes({char})
            
        elseif char == "-" then
            task.wait(delaySec * 0.12) -- Pauză scurtă pentru fiecare liniuță (sustain effect)
            
        elseif char == " " then
            task.wait(delaySec * 0.3) 
            
        elseif char == "\n" then
            task.wait(delaySec * 0.5) 
        end
        
        i = i + 1
    end
    isPlaying = false
end

-- ==================== GUI ====================
if targetGui:FindFirstChild("PianoAutoPlayer") then
    targetGui.PianoAutoPlayer:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PianoAutoPlayer"
ScreenGui.Parent = targetGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 110)
MainFrame.Position = UDim2.new(0.5, -120, 0.8, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Piano Auto - Custom Song"
Title.TextColor3 = Color3.fromRGB(150, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local PlayBtn = Instance.new("TextButton")
PlayBtn.Size = UDim2.new(0.42, 0, 0, 35)
PlayBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
PlayBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
PlayBtn.Text = "PLAY"
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayBtn.Parent = MainFrame

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0.42, 0, 0, 35)
StopBtn.Position = UDim2.new(0.53, 0, 0.5, 0)
StopBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
StopBtn.Text = "STOP"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Parent = MainFrame

Instance.new("UICorner", PlayBtn)
Instance.new("UICorner", StopBtn)

PlayBtn.MouseButton1Click:Connect(function()
    if not isPlaying then
        task.spawn(function() playSheet(sheetMusic) end)
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    isPlaying = false
end)