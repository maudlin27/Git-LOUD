
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Group = import('/lua/maui/group.lua').Group
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Checkbox = import('/lua/maui/checkbox.lua').Checkbox
local Button = import('/lua/maui/button.lua').Button
local GameMain = import('/lua/ui/game/gamemain.lua')
local Tooltip = import('/lua/ui/game/tooltip.lua')

local savedParent = false
local animationLock = false
local gameOver = false
local activeTab = false
local pauseBtn = false

timeoutsRemaining = false

if SessionIsMultiplayer() then
    local scenInfo = SessionGetScenarioInfo()
    timeoutsRemaining = tonumber(scenInfo.Options.Timeouts)
end

function CanUserPause()
    if timeoutsRemaining == false or timeoutsRemaining == -1 or timeoutsRemaining > 0 then
        return true
    else
        return false
    end
end

local pauseGlow = {
    Top = false,
}

local tabs = {
    {
        bitmap = 'menu',
        content = 'main',
        closeSound = 'UI_Main_Window_Close',
        openSound = 'UI_Main_Window_Open',
        tooltip = 'exit_menu',
    },
    {
        bitmap = 'diplomacy',
        content = 'diplomacy',
        disableInCampaign = true,
        disableInReplay = true,
        disableForObserver = true,
        closeSound = 'UI_Diplomacy_Close',
        openSound = 'UI_Diplomacy_Open',
        tooltip = 'diplomacy',
    },
    {
        pause = true,
        disableForObserver = true,
        tooltip = 'options_Pause',
    },
}

local menus = {
    main = {
        singlePlayer = {
            {
                action = 'Save',
                disableOnGameOver = true,
                label = '<LOC _Save_Game>Save Game',
                tooltip = 'esc_save',
            },
            {
                action = 'Load',
                label = '<LOC _Load_Game>Load Game',
                tooltip = 'esc_load',
            },
            {
                action = 'Options',
                label = '<LOC _Options>',
                tooltip = 'esc_options',
            },
            {
                action = 'RestartGame',
                label = '<LOC _Restart_Game>Restart Game',
                tooltip = 'esc_restart',
            },
            {
                action = 'EndSPGame',
                label = '<LOC _End_Game>',
                tooltip = 'esc_quit',
            },
            {
                action = 'ExitSPGame',
                label = '<LOC _Exit_to_Windows>',
                tooltip = 'esc_exit',
            },
            {
                action = 'Return',
                disableOnGameOver = true,
                label = '<LOC main_menu_9586>Close Menu',
                tooltip = 'esc_return',
            },
        },
        replay = {
            {
                action = 'LoadReplay',
                label = '<LOC _Load_Replay>Load Replay',
                tooltip = 'esc_load',
            },
            {
                action = 'Options',
                label = '<LOC _Options>',
                tooltip = 'esc_options',
            },
            {
                action = 'RestartReplay',
                label = '<LOC _Restart_Replay>Restart Replay',
                tooltip = 'esc_restart',
            },
            {
                action = 'EndMPGame',
                label = '<LOC _End_Replay>',
                tooltip = 'esc_quit',
            },
            {
                action = 'ExitMPGame',
                label = '<LOC _Exit_to_Windows>',
                tooltip = 'esc_exit',
            },
            {
                action = 'Return',
                disableOnGameOver = true,
                label = '<LOC main_menu_9586>Close Menu',
                tooltip = 'esc_return',
            },
        },
        lan = {
            {
                action = 'Options',
                label = '<LOC _Options>',
                tooltip = 'esc_options',
            },
            {
                action = 'Load_LAN',
                label = '<LOC _Load_Game>Load MP Game',
                tooltip = 'esc_load',
            },
            {
                action = 'Save_LAN',
                disableOnGameOver = true,
                label = '<LOC _Save_Game>Save MP Game',
                tooltip = 'esc_save',
            },
            {
                action = 'EndMPGame',
                label = '<LOC _End_Game>',
                tooltip = 'esc_quit',
            },
            {
                action = 'ExitMPGame',
                label = '<LOC _Exit_to_Windows>',
                tooltip = 'esc_exit',
            },
            {
                action = 'Return',
                disableOnGameOver = true,
                label = '<LOC main_menu_9586>Close Menu',
                tooltip = 'esc_return',
            },
        },
    },
}

local actions = {

    Save = function()
    
        local saveType

        saveType = "SaveGame"

        import('/lua/ui/dialogs/saveload.lua').CreateSaveDialog(GetFrame(0), nil, saveType)
    end,
	
    Load = function()

        saveType = "SaveGame"

        import('/lua/ui/dialogs/saveload.lua').CreateLoadDialog(GetFrame(0), nil, saveType)
    end,

    Save_LAN = function()
    
        local saveType

        saveType = "SaveLANGame"

        import('/lua/ui/dialogs/saveload.lua').CreateSaveDialog(GetFrame(0), nil, saveType)
    end,
	
    Load_LAN = function()

        saveType = "SaveLANGame"

        import('/lua/ui/dialogs/saveload.lua').CreateLoadDialog(GetFrame(0), nil, saveType)
    end,
    

	
    LoadReplay = function()
        import('/lua/ui/dialogs/replay.lua').CreateDialog(GetFrame(0), true)
    end,
	
    EndSPGame = function()
        UIUtil.QuickDialog(GetFrame(0), "<LOC EXITDLG_0001>Are you sure you'd like to quit?", 
            "<LOC _Yes>", EndGame,
            "<LOC _Save>", EndGameSaveWindow,
            "<LOC _No>", nil,
            true,
            {escapeButton = 3, enterButton = 1, worldCover = true})
    end,
	
    EndMPGame = function()
        UIUtil.QuickDialog(GetFrame(0), "<LOC EXITDLG_0001>Are you sure you'd like to quit?",
        "<LOC _Yes>", EndGame, 
        "<LOC _No>", nil,
            nil, nil,
            true,
            {escapeButton = 3, enterButton = 1, worldCover = true})
    end,
	
    RestartGame = function()
        UIUtil.QuickDialog(GetFrame(0), "<LOC EXITDLG_0002>Are you sure you'd like to restart?", 
            "<LOC _Yes>", function() RestartSession() end, 
            "<LOC _No>", nil,
            nil, nil,
            true,
            {escapeButton = 2, enterButton = 1, worldCover = true})
    end,
	
    RestartReplay = function()
        local replayFilename = GetFrontEndData('replay_filename')
        UIUtil.QuickDialog(GetFrame(0), "<LOC EXITDLG_0002>Are you sure you'd like to restart?", 
            "<LOC _Yes>", function() LaunchReplaySession(replayFilename) end, 
            "<LOC _No>", nil)
    end,
	
    ExitSPGame = function()
        UIUtil.QuickDialog(GetFrame(0), "<LOC EXITDLG_0003>Are you sure you'd like to exit?", 
            "<LOC _Yes>", function()
                ExitApplication()
            end, 
            "<LOC _Save>", ExitGameSaveWindow,
            "<LOC _No>", nil,
            true,
            {escapeButton = 3, enterButton = 1, worldCover = true})
    end,
	
    ExitMPGame = function()
        UIUtil.QuickDialog(GetFrame(0), "<LOC EXITDLG_0003>Are you sure you'd like to exit?", 
            "<LOC _Yes>", function()
                ExitApplication()
            end, 
            "<LOC _No>", nil,
            nil, nil,
            true,
            {escapeButton = 2, enterButton = 1, worldCover = true})
    end,
	
    Return = function()
        CollapseWindow()
    end,
	
    Options = function()
        import('/lua/ui/dialogs/options.lua').CreateDialog(GetFrame(0))
    end,
}

function EndGame()

    import('/lua/ui/dialogs/score.lua').CreateDialog()

end

function EndGameSaveWindow()

    local saveType

    saveType = 'SaveGame'

    function SaveKillBehavior(cancelled)
        if not cancelled then
            EndGame()
        end
    end

    import('/lua/ui/dialogs/saveload.lua').CreateSaveDialog(GetFrame(0), SaveKillBehavior, saveType)
end

function ExitGameSaveWindow()

    local saveType

    saveType = 'SaveGame'

    function SaveKillBehavior(cancelled)
        if not cancelled then
            ExitApplication()
        end
    end

    import('/lua/ui/dialogs/saveload.lua').CreateSaveDialog(GetFrame(0), SaveKillBehavior, saveType)
end

controls = {
    parent = false,
    bgBottomGlow = false,
    bgTopGlow = false,
    bgStretch = false,
}

function CreateStretchBar(parent, topPiece)
    local group = Group(parent)
    group.center = Bitmap(group)
    group.left = Bitmap(group)
    group.right = Bitmap(group)
    
    LayoutHelpers.AtHorizontalCenterIn(group.center, group)
    LayoutHelpers.AtTopIn(group.center, group)
    LayoutHelpers.AtLeftIn(group.left, group)
    LayoutHelpers.AtTopIn(group.left, group)
    LayoutHelpers.AtRightIn(group.right, group)
    LayoutHelpers.AtTopIn(group.right, group)
    
    if topPiece then
        group.centerLeft = Bitmap(group)
        LayoutHelpers.AtTopIn(group.centerLeft, group.center, 8)
        group.centerLeft.Left:Set(group.left.Right)
        group.centerLeft.Right:Set(group.center.Left)
        
        group.centerRight = Bitmap(group)
        group.centerRight.Top:Set(group.centerLeft.Top)
        group.centerRight.Left:Set(group.center.Right)
        group.centerRight.Right:Set(group.right.Left)
        
        group.Width:Set(function() return group.right.Width() + group.left.Width() + group.center.Width() end)
    else
        group.center.Left:Set(group.left.Right)
        group.center.Right:Set(group.right.Left)
    end
    
    group.Height:Set(function() return math.max(group.center.Height(), group.left.Height()) end)
    
    group:DisableHitTest(true)
    
    return group
end

function Create(parent)
    savedParent = parent
    
    controls.parent = Group(savedParent)
    controls.parent.Depth:Set(100)
    
    controls.bgTop = CreateStretchBar(controls.parent, true)
    controls.bgBottom = CreateStretchBar(controls.parent)
    controls.bgBottom.Width:Set(controls.bgTop.Width)
    
    controls.collapseArrow = Checkbox(savedParent)
    Tooltip.AddCheckboxTooltip(controls.collapseArrow, 'menu_collapse')
    
    controls.tabContainer = Group(controls.bgTop)
    controls.tabContainer:DisableHitTest()
    
    local function CreateTab(data)
        local tab = Checkbox(controls.tabContainer)
        tab.Depth:Set(function() return controls.bgTop.Depth() + 10 end)
        tab.Data = data
        Tooltip.AddCheckboxTooltip(tab, data.tooltip)
        
        if data.pause then
            tab.Glow = Bitmap(tab)
            LayoutHelpers.AtCenterIn(tab.Glow, tab)
            tab.Glow:DisableHitTest()
            tab.Glow:SetAlpha(0)
        end
        
        return tab
    end
    
    controls.tabs = {}
    for i, data in tabs do
        local index = i
        controls.tabs[index] = CreateTab(data)
        if data.pause then
            pauseBtn = controls.tabs[index]
        end
    end
    
    SetLayout()
    CommonLogic()
end

function SetLayout()
    import(UIUtil.GetLayoutFilename('tabs')).SetLayout()
    if activeTab then
        CreateStretchBG()
        controls.bgTop.Width:Set(controls.contentGroup.Width)
        controls.bgBottom.Top:Set(controls.contentGroup.Bottom)
    end
end

function CommonLogic()
    for i, tab in controls.tabs do
    
        if  tab.Data.disableInReplay and SessionIsReplay() then
            tab:Disable()
        elseif tab.Data.disableForObserver and GetFocusArmy() == -1 then
            tab:Disable()
        end
        
        if tab.Data.pause then

            if not CanUserPause() then
                tab:Disable()
            end

            tab.Glow.Time = 0
            tab.Glow.OnFrame = function(self, delta)
                self.Time = self.Time + (delta * 10)
                local newAlpha = MATH_Lerp(math.sin(self.Time), -1, 1, 0, .5)
                self:SetAlpha(newAlpha)
                if self.LastCycle and newAlpha < .1 then
                    self:SetNeedsFrameUpdate(false)
                    self:SetAlpha(0)
                end
            end
            tab.OnCheck = function(self, checked)
                if checked then
                    if not CanUserPause() then
                        return
                    end
                    SessionRequestPause()
                    self:SetGlowState(checked)
                else
                    SessionResume()
                    self:SetGlowState(checked)
                end
            end
            tab.OnClick = function(self, modifiers)
                if self._checkState == "unchecked" then
                    if CanUserPause() then
                        self:ToggleCheck()
                    end
                else
                    self:ToggleCheck()
                    if not CanUserPause() then
                        self:Disable()
                    end
                end
            end
            tab.SetGlowState = function(self, state)
                if state then
                    self.Glow.LastCycle = false
                    self.Glow.Time = 0
                    self.Glow:SetNeedsFrameUpdate(true)
                else
                    self.Glow.LastCycle = true
                end
            end
        else
            tab.OnCheck = function(self, checked)
                for _, altTab in controls.tabs do
                    if altTab != self and not altTab.Data.pause then
                        altTab:SetCheck(false, true)
                    end
                end
                if checked then
                    local sound = Sound({Cue = self.Data.openSound, Bank = "Interface",})
                    PlaySound(sound)
                    BuildContent(self.Data.content)
                else
                    local sound = Sound({Cue = self.Data.closeSound, Bank = "Interface",})
                    PlaySound(sound)
                    CollapseWindow()
                end
            end
            tab.OnClick = function(self, modifiers)
                if not animationLock then
                    self:ToggleCheck()
                end
            end
        end
    end
    controls.collapseArrow.OnCheck = function(self, checked)
        ToggleTabDisplay()
    end
end

local alphaFadeTime = 0.25
local heightResizeTime = 0.25
local widthResizeTime = 0.075

function BuildContent(contentID)
    ToggleTabDisplay(true)
    controls.collapseArrow:SetCheck(false, true)
    if controls.contentGroup then
        CollapseWindow(function() BuildContent(contentID) end)
        return
    end
	
    import('/lua/ui/game/multifunction.lua').CloseMapDialog()
    import('/lua/ui/game/chat.lua').CloseChatConfig()
	
    activeTab = contentID
    for _, tab in controls.tabs do
        if tab.Data.content == contentID then
            tab:SetCheck(true, true)
        end
    end
    local contentGroup = false
    if menus[contentID] then
        contentGroup = Group(controls.parent)

        local function BuildButton(button)
            local btn = UIUtil.CreateButtonStd(contentGroup, '/game/medium-btn/medium', button.label, UIUtil.menuFontSize)
            btn.label:SetFont(UIUtil.factionFont, UIUtil.menuFontSize)
            if button.action and actions[button.action] then
                btn.OnClick = function() CollapseWindow(actions[button.action]) end
            end
            LayoutHelpers.AtVerticalCenterIn(btn.label, btn, 4)
            return btn
        end

        local tableID = 'singlePlayer'
        if HasCommandLineArg('/gpgnet') then
            tableID = 'gpgnet'
        elseif SessionIsMultiplayer() then
            tableID = 'lan'
        elseif GameMain.GetReplayState() then
            tableID = 'replay'
        end

        contentGroup.Buttons = {}

        for index, buttonData in menus[contentID][tableID] do
            local i = index
            contentGroup.Buttons[i] = BuildButton(buttonData)
            if gameOver and buttonData.disableOnGameOver then
                contentGroup.Buttons[i]:Disable()
            end
            if i == 1 then
                LayoutHelpers.AtTopIn(contentGroup.Buttons[i], contentGroup)
                LayoutHelpers.AtHorizontalCenterIn(contentGroup.Buttons[i], contentGroup)
            else
                LayoutHelpers.Below(contentGroup.Buttons[i], contentGroup.Buttons[i-1])
            end
        end

        controls.bgTop.widthOffset = LayoutHelpers.ScaleNumber(4)
        contentGroup.Width:Set(contentGroup.Buttons[1].Width)
        contentGroup.Height:Set(function() return contentGroup.Buttons[1].Height() * table.getsize(contentGroup.Buttons) end)
    else
        controls.bgTop.widthOffset = LayoutHelpers.ScaleNumber(30)
        contentGroup = import('/lua/ui/game/'..contentID..'.lua').CreateContent(controls.parent)
    end

    animationLock = true

    LayoutHelpers.AnchorToBottom(contentGroup, controls.bgTop, 20)
    LayoutHelpers.AtHorizontalCenterIn(contentGroup, controls.bgTop)
    contentGroup.Time = 0
    contentGroup:SetAlpha(0, true)
    contentGroup.OnFrame = function(self, delta)
        self.Time = self.Time + delta
        local animationProgress = math.min(self.Time / alphaFadeTime, 1)
        if animationProgress == 1 then
            self:SetNeedsFrameUpdate(false)
        end
        self:SetAlpha(animationProgress, true)
    end

    controls.contentGroup = contentGroup

    CreateStretchBG()
    controls.bgTop:SetNeedsFrameUpdate(true)
    controls.bgTop.Time = 0
    controls.bgTop.OnFrame = function(self, delta)
        self.Time = self.Time + delta
        local animationProgress = math.min(self.Time / widthResizeTime, 1)

        if (animationProgress == 1) then
            self:SetNeedsFrameUpdate(false)
            controls.bgBottom:SetNeedsFrameUpdate(true)
        end

        self.Width:Set(MATH_Lerp(animationProgress, self.defWidth, math.max(controls.contentGroup.Width() + self.widthOffset, self.defWidth)))
    end
    controls.bgBottom.Time = 0
    controls.bgBottom.OnFrame = function(self, delta)
        self.Time = self.Time + delta
        local animationProgress = math.min(self.Time / heightResizeTime, 1)

        if (animationProgress < 1) then
            self.Top:Set(MATH_Lerp(animationProgress, controls.bgTop.Bottom(), controls.contentGroup.Bottom()))
        else
            controls.contentGroup:SetNeedsFrameUpdate(true)
            self:SetNeedsFrameUpdate(false)
            animationLock = false
            self.Top:Set(controls.contentGroup.Bottom)
        end
    end
end

function CollapseWindow(callback)
    if activeTab then
        animationLock = true
        for _, tab in controls.tabs do
            if not tab.Data.pause then
                tab:SetCheck(false, true)
            end
        end
        activeTab = false
        local origWidth = controls.contentGroup.Width()
        local origHeight = controls.contentGroup.Bottom()
        controls.bgBottom:SetNeedsFrameUpdate(false)
        controls.contentGroup.Time = 0
        controls.contentGroup:SetNeedsFrameUpdate(true)
        controls.contentGroup.OnFrame = function(self, delta)
            self.Time = self.Time + delta
            local animationProgress = math.min(self.Time / alphaFadeTime, 1)
            if animationProgress == 1 then
                controls.bgBottom:SetNeedsFrameUpdate(true)
                controls.contentGroup:Destroy()
                controls.contentGroup = false
            end
            self:SetAlpha(1 - animationProgress, true)
        end
        controls.bgBottom.Time = 0
        controls.bgBottom.OnFrame = function(self, delta)
            self.Time = self.Time + delta
            local animationProgress = math.min(self.Time / heightResizeTime, 1)

            if (animationProgress < 1) then
                self.Top:Set(MATH_Lerp(animationProgress, origHeight, controls.bgTop.Bottom()))
            else
                self:SetNeedsFrameUpdate(false)
                controls.bgTop:SetNeedsFrameUpdate(true)
                self.Top:Set(controls.bgTop.Bottom)
            end
        end
        controls.bgTop.Time = 0
        controls.bgTop.OnFrame = function(self, delta)
            self.Time = self.Time + delta
            local animationProgress = math.min(self.Time / widthResizeTime, 1)

            if (animationProgress == 1) then
                self:SetNeedsFrameUpdate(false)
                DestroyStretchBG()
                animationLock = false
                if callback then
                    callback()
                end
            end
            self.Width:Set(MATH_Lerp(animationProgress, math.max(origWidth + self.widthOffset, self.defWidth), self.defWidth))
        end
    end
end

function CreateStretchBG()
    if not controls.bgBottomLeftGlow then
        controls.bgBottomLeftGlow = Bitmap(controls.parent)
    end
    if not controls.bgTopLeftGlow then
        controls.bgTopLeftGlow = Bitmap(controls.parent)
    end
    if not controls.bgLeftStretch then
        controls.bgLeftStretch = Bitmap(controls.parent)
    end
    if not controls.bgBottomRightGlow then
        controls.bgBottomRightGlow = Bitmap(controls.parent)
    end
    if not controls.bgTopRightGlow then
        controls.bgTopRightGlow = Bitmap(controls.parent)
    end
    if not controls.bgRightStretch then
        controls.bgRightStretch = Bitmap(controls.parent)
    end
    if not controls.bgMidStretch then
        controls.bgMidStretch = Bitmap(controls.parent)
    end
    import(UIUtil.GetLayoutFilename('tabs')).LayoutStretchBG()
end

function DestroyStretchBG() 
    controls.bgBottomLeftGlow:Destroy()
    controls.bgBottomLeftGlow = false
    
    controls.bgTopLeftGlow:Destroy()
    controls.bgTopLeftGlow = false
    
    controls.bgLeftStretch:Destroy()
    controls.bgLeftStretch = false
    
    controls.bgBottomRightGlow:Destroy()
    controls.bgBottomRightGlow = false
    
    controls.bgTopRightGlow:Destroy()
    controls.bgTopRightGlow = false
    
    controls.bgRightStretch:Destroy()
    controls.bgRightStretch = false
    
    controls.bgMidStretch:Destroy()
    controls.bgMidStretch = false
end

function ToggleTab(tabID)
    if not controls.tabs then return end
    local tabControl = false
    tabID = tabID or activeTab
    for _, tab in controls.tabs do
        if tab.Data.content == tabID then
            tabControl = tab
            break
        end
    end
    if tabControl and not tabControl:IsDisabled() then  
        tabControl:OnClick()
    end
end

function OnGameOver()
    gameOver = true
    for i, tab in controls.tabs do
        if tab.Data.disableForObserver then
            tab:Disable()
        end
    end
end

function OnPause(state, pausedBy, lTimeoutsRemaining, isOwner)
    pauseBtn:SetCheck(state, true)
    pauseBtn:SetGlowState(state)
    local text = '<LOC pause_0001>Game Resumed'
    local owner = false
    if state then
        CreateScreenGlow()
        text = '<LOC pause_0002>Game Paused'
    else
        HideScreenGlow()
    end
    if not isOwner and pausedBy then
        owner = LOCF('<LOC pause_0000>By %s', SessionGetCommandSourceNames()[pausedBy])
    end

    if lTimeoutsRemaining and isOwner then
        timeoutsRemaining = lTimeoutsRemaining
    end

    if state then
        Tooltip.SetTooltipText(pauseBtn, LOC('<LOC tooltipui0098>'))
        Tooltip.AddCheckboxTooltip(pauseBtn, 'options_Play')
    else
        Tooltip.SetTooltipText(pauseBtn, LOC('<LOC tooltipui0195>'))
        Tooltip.AddCheckboxTooltip(pauseBtn, 'options_Pause')
    end
    import('/lua/ui/game/announcement.lua').CreateAnnouncement(text, pauseBtn, owner)
end

function TogglePause()
    if CanUserPause() then
        pauseBtn:ToggleCheck()
    end
end

function CreateScreenGlow()
    if not pauseGlow.Top then
        pauseGlow.Top = Bitmap(GetFrame(0), UIUtil.SkinnableFile('/game/pause-indicator/top.dds'))
        pauseGlow.Left = Bitmap(pauseGlow.Top, UIUtil.SkinnableFile('/game/pause-indicator/left.dds'))
        pauseGlow.Right = Bitmap(pauseGlow.Top, UIUtil.SkinnableFile('/game/pause-indicator/right.dds'))
        pauseGlow.Bottom = Bitmap(pauseGlow.Top, UIUtil.SkinnableFile('/game/pause-indicator/bottom.dds'))
        pauseGlow.Center = Bitmap(pauseGlow.Top)
        pauseGlow.Center:SetSolidColor('55000000')
        
        pauseGlow.Top.Top:Set(GetFrame(0).Top)
        pauseGlow.Top.Left:Set(GetFrame(0).Left)
        pauseGlow.Top.Right:Set(GetFrame(0).Right)
        
        pauseGlow.Left.Top:Set(GetFrame(0).Top)
        pauseGlow.Left.Left:Set(GetFrame(0).Left)
        pauseGlow.Left.Bottom:Set(GetFrame(0).Bottom)
        
        pauseGlow.Right.Top:Set(GetFrame(0).Top)
        pauseGlow.Right.Right:Set(GetFrame(0).Right)
        pauseGlow.Right.Bottom:Set(GetFrame(0).Bottom)
        
        pauseGlow.Bottom.Left:Set(GetFrame(0).Left)
        pauseGlow.Bottom.Right:Set(GetFrame(0).Right)
        pauseGlow.Bottom.Bottom:Set(GetFrame(0).Bottom)
        
        LayoutHelpers.FillParent(pauseGlow.Center, GetFrame(0))
        pauseGlow.Center.Depth:Set(function() return pauseGlow.Top.Depth() - 1 end)
        
        pauseGlow.Top:DisableHitTest(true)
    end
    pauseGlow.Top:SetNeedsFrameUpdate(true)
    pauseGlow.Top:SetAlpha(0, true)
    pauseGlow.Top.OnFrame = function(self, delta)
        local newAlpha = self:GetAlpha() + delta
        if newAlpha > .8 then
            newAlpha = .8
            self:SetNeedsFrameUpdate(false)
        end
        self:SetAlpha(newAlpha, true)
    end
    if import('/lua/ui/game/gamemain.lua').gameUIHidden then
        pauseGlow.Top:Hide()
    end
end

function HideScreenGlow()
    pauseGlow.Top:SetNeedsFrameUpdate(true)
    pauseGlow.Top.OnFrame = function(self, delta)
        local newAlpha = self:GetAlpha() - delta
        if newAlpha < 0 then
            newAlpha = 0
            self:SetNeedsFrameUpdate(false)
        end
        self:SetAlpha(newAlpha, true)
    end
end

function ToggleScore()
    if not controls.tabs then return end
    import('/lua/ui/game/score.lua').ToggleScoreControl()
end

function ToggleTabDisplay(state)
    if import('/lua/ui/game/gamemain.lua').gameUIHidden and state != nil then
        return
    end
    if UIUtil.GetAnimationPrefs() then
        if state or controls.parent:IsHidden() then
            PlaySound(Sound({Cue = "UI_Score_Window_Open", Bank = "Interface"}))
            controls.parent:Show()
            controls.parent:SetNeedsFrameUpdate(true)
            controls.parent.OnFrame = function(self, delta)
                local newTop = self.Top() + (500*delta)
                if newTop > savedParent.Top() then
                    newTop = savedParent.Top()
                    self:SetNeedsFrameUpdate(false)
                end
                self.Top:Set(newTop)
            end
        else
            PlaySound(Sound({Cue = "UI_Score_Window_Close", Bank = "Interface"}))
            local function CollapseTab()
                controls.parent:SetNeedsFrameUpdate(true)
                controls.parent.OnFrame = function(self, delta)
                    local newTop = self.Top() - (500*delta)
                    if newTop < savedParent.Top()-self.Height() then
                        newTop = savedParent.Top()-self.Height()
                        self:Hide()
                        self:SetNeedsFrameUpdate(false)
                    end
                    self.Top:Set(newTop)
                end
                controls.collapseArrow:SetCheck(true, true)
            end
            if controls.contentGroup then
                CollapseWindow(CollapseTab)
                return
            end
            CollapseTab()
        end
    else
        if state or controls.parent:IsHidden() then
            controls.parent:Show()
            controls.collapseArrow:SetCheck(false, true)
        else
            controls.parent:Hide()
            controls.collapseArrow:SetCheck(true, true)
        end
    end
end

function Contract()
    controls.parent:Hide()
    controls.collapseArrow:Hide()
    if pauseGlow.Top then
        pauseGlow.Top:Hide()
    end
end

function Expand()
    controls.parent:Show()
    controls.collapseArrow:Show()
    if pauseGlow.Top then
        pauseGlow.Top:Show()
    end
end

function InitialAnimation()
    controls.collapseArrow:Show()
    controls.parent.Top:Set(savedParent.Top()-controls.parent.Height())
    controls.parent:Show()
    controls.parent:SetNeedsFrameUpdate(true)
    controls.parent.OnFrame = function(self, delta)
        local newTop = self.Top() + (500*delta)
        if newTop > savedParent.Top() then
            newTop = savedParent.Top()
            self:SetNeedsFrameUpdate(false)
        end
        self.Top:Set(newTop)
    end
end

function TabAnnouncement(tabID, text)
    local tabControl = false
    for _, tab in controls.tabs do
        if tab.Data.content == tabID then
            tabControl = tab
            break
        end
    end
    if tabControl then
        import('/lua/ui/game/announcement.lua').CreateAnnouncement(LOC(text), tabControl)
    end
end

local modes = {}

function AddModeText(text, callback)
    local id = 1
    while modes[id] do
        id = id + 1
    end
    modes[id] = {label = text, callback = callback}
    UpdateModeDisplay()
    return id
end

function RemoveModeText(modeID)
    if modes[modeID] then
        modes[modeID] = nil
    end
    UpdateModeDisplay()
end

function UpdateModeDisplay()
    if controls.modeDisplay then
        controls.modeDisplay:Destroy()
        controls.modeDisplay = false
    end
    local modeNum = table.getsize(modes)
    if modeNum > 0 then
        controls.modeDisplay = Bitmap(controls.parent, UIUtil.SkinnableFile('/dialogs/time-units-tabs/energy_bmp.dds'))
        LayoutHelpers.Below(controls.modeDisplay, controls.bgBottom, -12)
        LayoutHelpers.AtHorizontalCenterIn(controls.modeDisplay, controls.bgBottom)
        
        controls.modeDisplay.modes = Group(controls.modeDisplay)
        LayoutHelpers.SetHeight(controls.modeDisplay.modes, 1)
        local prevControl = false
        local width = 0
        for i, v in modes do
            local bg = Bitmap(controls.modeDisplay, UIUtil.SkinnableFile('/dialogs/time-units-tabs/panel-tracking_bmp_m.dds'))
            
            if not v.callback then
                bg.text = UIUtil.CreateText(bg, LOC(v.label), 18, UIUtil.bodyFont)
                LayoutHelpers.AtLeftIn(bg.text, bg)
                LayoutHelpers.AtVerticalCenterIn(bg.text, bg)
                bg.text:DisableHitTest()
                bg.Width:Set(bg.text.Width)
            else
                bg.btn = UIUtil.CreateButtonStd(bg, '/widgets02/small', LOC(v.label), 16)
                LayoutHelpers.AtLeftIn(bg.btn, bg)
                LayoutHelpers.AtVerticalCenterIn(bg.btn, bg, -3)
                bg.btn.OnClick = v.callback
                
                bg.Width:Set(bg.btn.Width)
            end
            
            if prevControl then
                bg.seperator = Bitmap(bg, UIUtil.SkinnableFile('/dialogs/time-units-tabs/panel-tracking_bmp_d.dds'))
                LayoutHelpers.LeftOf(bg.seperator, bg)
                LayoutHelpers.AtVerticalCenterIn(bg.seperator, bg)
                LayoutHelpers.RightOf(bg, prevControl, 10)
                width = bg.Width() + bg.seperator.Width() + width
            else
                LayoutHelpers.AtLeftTopIn(bg, controls.modeDisplay.modes)
                width = bg.Width() + width
            end
            prevControl = bg
        end
        controls.modeDisplay.modes.Width:Set(width)
        LayoutHelpers.Below(controls.modeDisplay.modes, controls.modeDisplay, -5)
        LayoutHelpers.AtHorizontalCenterIn(controls.modeDisplay.modes, controls.modeDisplay)
        controls.modeDisplay.minCap = Bitmap(controls.modeDisplay.modes, UIUtil.SkinnableFile('/dialogs/time-units-tabs/panel-tracking_bmp_l.dds'))
        controls.modeDisplay.maxCap = Bitmap(controls.modeDisplay.modes, UIUtil.SkinnableFile('/dialogs/time-units-tabs/panel-tracking_bmp_r.dds'))
        controls.modeDisplay.minCap.Right:Set(controls.modeDisplay.modes.Left)
        LayoutHelpers.AtTopIn(controls.modeDisplay.minCap, controls.modeDisplay.modes, -3)
        controls.modeDisplay.maxCap.Left:Set(controls.modeDisplay.modes.Right)
        controls.modeDisplay.maxCap.Top:Set(controls.modeDisplay.minCap.Top)
        
        controls.modeDisplay:DisableHitTest()
        controls.modeDisplay.minCap:DisableHitTest()
        controls.modeDisplay.maxCap:DisableHitTest()
    end
end