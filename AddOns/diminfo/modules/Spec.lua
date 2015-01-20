local addon, ns = ...
local cfg = ns.cfg
local init = ns.init
local panel = CreateFrame("Frame", nil, UIParent)

if cfg.Spec == true then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("HIGH")
	Stat:SetFrameLevel(3)
	local Stat2 = CreateFrame("Frame")
	Stat2:EnableMouse(true)
	Stat2:SetFrameStrata("HIGH")
	Stat2:SetFrameLevel(3)
	
	local Text = panel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(unpack(cfg.Fonts))
	Text:SetPoint(unpack(cfg.SpecPoint))
	local Text2 = panel:CreateFontString(nil, "OVERLAY")
	Text2:SetFont(unpack(cfg.Fonts))
	Text2:SetPoint("LEFT", Text, "RIGHT", 1, 0)
	Stat2:SetAllPoints(Text2)
	
	local int = 1
	local function Update(self, t)
		if not GetSpecialization() then
			Text:SetText(infoL["Active Talent"] .. (cfg.ColorClass and init.Colored..infoL["No Talents"] or infoL["No Talents"]))
		return end
		int = int - t
		if int < 0 then
			local Spec = GetSpecialization()
			local _, SpecName = GetSpecializationInfo(Spec)
			Text:SetText(infoL["Active Talent"] .. (cfg.ColorClass and init.Colored..SpecName or SpecName))
		end
		
		local specID = GetLootSpecialization()
		if not GetSpecialization() then
			Text2:Hide()
		elseif specID == 0 then
			Text2:SetText("|T"..select(4, GetSpecializationInfo(GetSpecialization()))..":15:15:0:0:64:64:4:60:4:60|t")
		else
			Text2:SetText("|T"..select(4, GetSpecializationInfoByID(specID))..":15:15:0:0:64:64:4:60:4:60|t")
		end
	end

	local menuFrame = CreateFrame("Frame", "LootSpecMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true},
		{notCheckable = true, func = function() SetLootSpecialization(0) end},
		{notCheckable = true},
		{notCheckable = true},
		{notCheckable = true},
		{notCheckable = true}
	}
	
	local function Checktalentgroup(index)
		return GetSpecialization(false,false,index)
	end 
	
	local function OnEvent(self, event, ...) 
		if event == "PLAYER_LOGIN" then
			self:UnregisterEvent("PLAYER_LOGIN")
		end
		-- Setup Talents Tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function(self)
				local c = GetActiveSpecGroup(false,false)
				local majorTree1 = GetSpecialization(false,false,1)
				local spec1 = { }
				for i = 1, 7 do
					for j = 1, 3 do
						local talentID, name, iconTexture, selected, available = GetTalentInfo(i,j,1)
						if selected then
							table.insert(spec1,i.."-"..name)
						end
					end
				end
				local majorTree2 = GetSpecialization(false,false,2)
				local spec2 = { }
				if majorTree2 then
					for i = 1, 7 do
						for j = 1, 3 do
							local talentID, name, iconTexture, selected, available = GetTalentInfo(i,j,2)
							if selected then
								table.insert(spec2,i.."-"..name)
							end
						end
					end
				end
				GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(TALENTS_BUTTON,0,.6,1)
				GameTooltip:AddLine(" ")
				if GetNumSpecGroups() == 1 then
					GameTooltip:AddLine("|cff00FF00* |r" .. infoL["Talent"] .. init.Colored .. (GetSpecialization() and select(2,GetSpecializationInfo(majorTree1)) or infoL["none"])..": ",1,1,1)
					for i = 1, #spec1 do
						GameTooltip:AddDoubleLine(" ",init.Colored..spec1[i],1,1,1,1,1,1)
					end
				else
					GameTooltip:AddLine("|cff00FF00"..(c == 1 and "* " or "   ") .. "|r" .. select(2,GetSpecializationInfo(majorTree1))..": ",1,1,1)
					for i = 1, #spec1 do
						GameTooltip:AddDoubleLine(" ",init.Colored..spec1[i],1,1,1,1,1,1)
					end
					if not majorTree2 then return end
					GameTooltip:AddLine("|cff00FF00"..(c == 2 and "* " or "   ") .. "|r" .. select(2,GetSpecializationInfo(majorTree2))..": ",1,1,1)
					for i = 1, #spec2 do
						GameTooltip:AddDoubleLine(" ",init.Colored..spec2[i],1,1,1,1,1,1)
					end
				end
				GameTooltip:Show()
			end)
		
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	 
	Stat:RegisterEvent("PLAYER_LOGIN")
	Stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	Stat:SetScript("OnEvent", OnEvent)
	Stat:SetScript("OnUpdate", Update)
	Stat:SetScript("OnMouseDown", function(_,btn)
		if btn == "LeftButton" then
			ToggleTalentFrame()
		else
			c = GetActiveSpecGroup(false,false)
			SetActiveSpecGroup(c == 1 and 2 or 1)
		end
	end)
	
	Stat2:SetScript("OnEnter", function(self)
		if not GetSpecialization() then return end
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
		local specID = GetLootSpecialization()
		if specID == 0 then
			CUR_LOOT_SPEC = (select(2, GetSpecializationInfo(GetSpecialization())))
		else
			CUR_LOOT_SPEC = (select(2, GetSpecializationInfoByID(specID)))
		end
		GameTooltip:AddLine(format("%s: |cffffffff%s", SELECT_LOOT_SPECIALIZATION, CUR_LOOT_SPEC),0,.6,1,1,1,1)
		GameTooltip:Show()
	end)
	Stat2:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	Stat2:SetScript("OnMouseUp", function()
		local specID, specName = GetSpecializationInfo(GetSpecialization())
		for i = 1, 4 do
			menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, specName)
			local id, name = GetSpecializationInfo(i)
			if id then
				menuList[i+2].text = name
				menuList[i+2].func = function() SetLootSpecialization(id) end
			else
				menuList[i+2] = nil
			end
		end
		EasyMenu(menuList, menuFrame, "cursor", 5, 0, "MENU", 2)
	end)
end
