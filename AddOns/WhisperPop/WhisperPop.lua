------------------------------------------------------------
-- WhisperPop.lua
--
-- Abin
-- 2010-9-28
------------------------------------------------------------

WhisperPop = {}
WhisperPop.version = GetAddOnMetadata("WhisperPop", "Version") or "3.0"
WhisperPop.IGNORED_MESSAGES = { "<DBM>", "<BWS>", "<BigWigs>", "<BIGWIGS>", "LVBM" } -- Add your ignore tags
WhisperPop.db = { sound = 1, time = 1, help = 1 }
WhisperPop.newNames = {}
WhisperPop.filter = {
	"宝搜",
	"加Q",
	"竞技",
	"TB搜",
	"兽团",
	"信誉",
	"下单",
	"网游",
	"速带",
	"查店",
	"平台",
	"平臺",
	"工作室",
	"专卖店",
	"大卡",
	"小卡",
	"点卡",
	"点心",
	"點卡",
	"點心",
	"烧饼",
	"大饼",
	"小饼",
	"烧圆形",
	"大圆形",
	"小圆形",
	"烧rt2",
	"大rt2",
	"小rt2",
	"rt2rt2",
	"担保",
	"擔保",
	"承接",
	"手工",
	"手打",
	"代打",
	"代练",
	"代刷",
	"带打",
	"带练",
	"带刷",
	"dai打",
	"dai练",
	"dai刷",
	"带评级",
	"代评级",
	"打金",
	"卖金",
	"售金",
	"出金",
	"萬金",
	"万金",
	"w金",
	"打g",
	"卖g",
	"售g",
	"萬g",
	"万g",
	"wg",
	"详情",
	"详谈",
	"详询",
	"信誉",
	"信赖",
	"充值",
	"储值",
	"服务",
	"套餐",
	"刷屏[勿见]",
	"扰屏[勿见]",
	"绑定.*上马",
	"上马.*绑定",
	"价格公道",
	"货到付款",
	"非诚勿扰",
	"先.*后钱",
	"先.*后款",
	"价.*优惠",
	"代.*s1",
	"售.*s1",
	"游戏币",
	"最低价",
	"无黑金",
	"不封号",
	"无风险",
	"好再付",
	"年老店",
	"金=",
	"g=",
	"元=",
	"5173",
	"支付宝",
	"支付寶",
	"淘宝",
	"淘寶",
	"皇冠",
	"冲冠",
	"热销",
	"促销",
	"加q",
	"企业q",
	"咨询",
	"联系",
	"电话",
	"旺旺",
	"口口",
	"扣扣",
	"叩叩",
	"歪歪",
	"丫丫",
	"大神带你打",
	"高手帮忙打",
	"竞技场大师",
	"血腥舞钢fm",
	"满及",
	"taobao",
	"8o",
	"9o",
	"八[o0]",
	"九[o0]",
	"０",
	"○",
	"①",
	"②",
	"③",
	"④",
	"⑤",
	"⑥",
	"⑦",
	"⑧",
	"⑨",
	"泏",
	"釒",
}

function WhisperPop:IsIgnoredMessage(text)
	local pattern
	for _, pattern in ipairs(self.IGNORED_MESSAGES) do
		if strfind(text, pattern) then
			return pattern
		end
	end
end

function WhisperPop:IsFilterMessage(text)
	local pattern
	local dofilter = false
	for _, pattern in ipairs(self.filter) do
		if strfind(text, pattern) then
			dofilter = true
		end
	end
	return dofilter
end

function WhisperPop:CreateCommonFrame(name, parent, titleText)
	local frame = CreateFrame("Button", name, parent)
	frame:Hide()
	frame:SetWidth(165)
	frame:SetHeight(262)
	frame:SetClampedToScreen(true)
	frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 } })

	local title = frame:CreateFontString(name.."Title", "ARTWORK", "GameFontNormal")
	title:SetPoint("TOP", 0, -7)
	title:SetText(titleText)
	frame.title = title

	local button = CreateFrame("Button", name.."CloseButton", frame, "UIPanelCloseButton")
	frame.topClose = button
	button:SetPoint("TOPRIGHT", -2, -2)
	button:SetWidth(24)
	button:SetHeight(24)

	return frame
end

function WhisperPop:CreatePlayerButton(button, name, parent)
	if not button then
		button = CreateFrame("Frame", name, parent)
		button:SetWidth(100)
		button:SetHeight(20)
	end

	button.classIcon = button:CreateTexture(button:GetName().."ClassIcon", "ARTWORK")	
	button.classIcon:SetWidth(16)
	button.classIcon:SetHeight(16)
	button.classIcon:SetPoint("LEFT", 4, 0)

	button.nameText = button:CreateFontString(button:GetName().."NameText", "ARTWORK", "GameFontHighlightSmallLeft")
	button.nameText:SetPoint("LEFT", button.classIcon, "RIGHT", 2, 0)

	button.SetPlayer = function(self, class, name)			
		self.nameText:SetText(name)
		local coords = CLASS_BUTTONS[class]
		if coords then
			self.classIcon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
			self.classIcon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
			self.classIcon:Show()
		elseif class == "GM" then
			self.classIcon:SetTexture("Interface\\AddOns\\WhisperPop\\GM")
			self.classIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			self.classIcon:Show()
		elseif class == "BN" then
			self.classIcon:SetTexture("Interface\\AddOns\\WhisperPop\\BN")
			self.classIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			self.classIcon:Show()
		else
			self.classIcon:Hide()
		end
	end

	return button
end

function WhisperPop:OnNewMessage(name, text, inform, guid)
	if not inform and self.db.sound then
		PlaySoundFile("Interface\\AddOns\\WhisperPop\\Notify.mp3") -- Got new message!
	end
end

function WhisperPop:GetNumNewNames()
	return getn(self.newNames)
end

function WhisperPop:GetNewName(id)
	return self.newNames[id or 1]
end

function WhisperPop:OnListUpdate()
	wipe(self.newNames)
	local i
	for i = 1, self.list:GetDataCount() do
		local data = self.list:GetData(i)
		if data.new then
			tinsert(self.newNames, data.name)
		end
	end

	self.tipFrame:SetTip(self.newNames[1])
end

function WhisperPop:ToggleFrame()
	if WhisperPop.mainFrame:IsShown() then
		WhisperPop.mainFrame:Hide()
	else
		WhisperPop.mainFrame:Show()
	end
end