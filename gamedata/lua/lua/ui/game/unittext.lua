local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')

function FloatingEntityText(entryData)

	if entryData.entity != nil and GetUnitById(entryData.entity) != nil then

		local views = import('/lua/ui/game/worldview.lua').GetWorldViews()
	
		for _, viewControl in views do
	
			local view = viewControl
			local text = UIUtil.CreateText(view, entryData.text, 20, UIUtil.bodyFont)
		
			text:SetDropShadow(true)
			text:SetColor('ffff7f00')
			text:DisableHitTest()
			
			text.coords = GetUnitById(entryData.entity):GetPosition()
			text.time = 0
			text:SetAlpha(1)
			text:SetNeedsFrameUpdate(true)
			
			text.UpdatePosition = function(self)
				local coords = view:Project(self.coords)
				self.Left:Set(function() return coords[1] - (self.Width() * .5) end)
				self.Top:Set(function() return coords[2] - (32 * self.time) end)
			end
		
			text.OnFrame = function(self, delta)
            
				self.time = self.time + (delta * .1)
				
				if GetUnitById(entryData.entity) then
                
					if GetCamera(view._cameraName):GetTargetZoom() > 145 then

                        self:Hide()

					else

                        self:Show()

					end
                    
					self:UpdatePosition()
                    
					local newAlpha = self:GetAlpha() - (delta * .2)
                    
					if newAlpha < 0 then
						text:Destroy()
						newAlpha = 0
					end
                    
					self:SetAlpha(newAlpha)
                    
				else
					self:Destroy()
				end
			end
		
			text:UpdatePosition()
		end
	
	end
end

local timers = {}

function StartCountdown(entryData)
    local views = import('/lua/ui/game/worldview.lua').GetWorldViews()
    for _, viewControl in views do
        local view = viewControl
        if not timers[view._cameraName] then
            timers[view._cameraName] = {}
        end
        if timers[view._cameraName][entryData.entity] then
            timers[view._cameraName][entryData.entity]:Destroy()
        end
        timers[view._cameraName][entryData.entity] = UIUtil.CreateText(view, '5', 18, UIUtil.bodyFont)
        local text = timers[view._cameraName][entryData.entity]
        text:SetDropShadow(true)
        text:SetColor('ffff7f00')
        text:DisableHitTest()
        text.userEntity = GetUnitById(entryData.entity)
        text.position = text.userEntity:GetPosition()
        text.time = 0
        text.curTime = 5
        text.startTime = GetGameTimeSeconds()
        text:SetAlpha(1)
        text:SetNeedsFrameUpdate(true)
        text.UpdateTick = function(self)
            if self.userEntity and not self.userEntity:IsDead() then
                self.position = self.userEntity:GetPosition()
                self:SetAlpha(1)
                self:SetText(self.curTime)
            else
                self:Destroy()
                timers[view._cameraName][entryData.entity] = nil
            end
        end
        text.UpdatePosition = function(self)
            local coords = view:Project(self.position)
            self.Left:Set(function() return view.Left() + coords[1] - (self.Width() / 2) end)
            self.Top:Set(function() return view.Top() + coords[2] - 30 end)
        end
        text.OnFrame = function(self, delta)
            self.time = self.time + delta
            if not self.userEntity or self.time > 5 then
                self:Destroy()
                timers[view._cameraName][entryData.entity] = nil
            end
            if GetCamera(view._cameraName):GetTargetZoom() > 130 then
                self:Hide()
            elseif self.Right() > view.Right() then
                self:Hide()
            elseif self.Left() < view.Left() then
                self:Hide()
            elseif self.Bottom() > view.Bottom() then
                self:Hide()
            elseif self.Top() < view.Top() then
                self:Hide()
            else
                self:Show()
            end
            if GetGameTimeSeconds() - self.startTime > 1 then
                self.curTime = self.curTime - 1
                self.startTime = GetGameTimeSeconds()
                self:UpdateTick()
            end
            self:SetAlpha(math.max(self:GetAlpha() - delta, 0))
            self:UpdatePosition()
        end
        text:UpdatePosition()
    end
end

function CancelCountdown(entryData)
    local views = import('/lua/ui/game/worldview.lua').GetWorldViews()
    for _, viewControl in views do
        local view = viewControl
        if timers[view._cameraName][entryData.entity] then
            local timer = timers[view._cameraName][entryData.entity]
            timer:SetText("Cancelled")
            timer:SetAlpha(1)
            timer.OnFrame = function(self, delta)
                local newAlpha = self:GetAlpha() - delta
                if newAlpha < 0 then
                    newAlpha = 0
                    self:Destroy()
                    timers[view._cameraName][entryData.entity] = nil
                end
                self:SetAlpha(newAlpha)
            end
        end
    end
end