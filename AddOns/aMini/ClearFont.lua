-- /////////////////////////////////////////////////////////////////////////////
-- =============================================================================
--  ClearFont v4.01a ̨���û��ˣ�����4.1���ã�2011-07-14�޸�̨���ֱ�ͻ��ˣ�
--  ������ClearFont v20000-2 �汾�����޸ģ�
--  ԭ���ߣ�KIRKBURN��ԭ�����Ѳ��ٸ��£���
--  �ٷ���ҳ��http://www.clearfont.co.uk/
--  �����޸ģ����� Ԫ��֮�� ��Ϯ����/̨�� �������� ��Ϯ����
--  ����ҳ�棺http://bbs.game.mop.com/viewthread.php?tid=1503056
--  �������ڣ�2010.10.19
-- -----------------------------------------------------------------------------
--  CLEARFONT.LUA - STANDARD WOW UI FONTS
--	A. ClearFont ��� ��Ϊ���������ļ���Ԥ�ȶ�������λ��
--	B. ��׼��WOW�û����沿��
--	C. ÿ��һ���������ʱ����������Ĺ���
--	D. ��һ������ʱӦ�������趨
-- =============================================================================
-- /////////////////////////////////////////////////////////////////////////////




-- =============================================================================
--  A. ClearFont ��� ��Ϊ���������ļ���Ԥ�ȶ�������λ��
--  ����Ը��ݷ����������Լ�������
-- =============================================================================

	ClearFont = CreateFrame("Frame", "ClearFont");

-- ָ��������Ѱ������
	local CLEAR_FONT_BASE = "Fonts\\";

-- ��ҡ��ѵ��������󶨵�����
	local CLEAR_FONT_NUMBER = CLEAR_FONT_BASE .. "ARKai_T.ttf";
-- ���������������ϵ�����
	local CLEAR_FONT_EXP = CLEAR_FONT_BASE .. "ARKai_T.ttf";
-- ����˵�������š�ʯ������������
	local CLEAR_FONT_QUEST = CLEAR_FONT_BASE .. "ARKai_T.ttf";
-- ս���˺���ֵ��ʾ
	local CLEAR_FONT_DAMAGE = CLEAR_FONT_BASE .. "ARKai_T.ttf";
-- ��Ϸ�����е���Ҫ����
	local CLEAR_FONT = CLEAR_FONT_BASE .. "ARKai_T.ttf";
-- ��Ʒ�����ܵ�˵������
	local CLEAR_FONT_ITEM = CLEAR_FONT_BASE .. "ARKai_T.ttf";
-- ��������
	local CLEAR_FONT_CHAT = CLEAR_FONT_BASE .. "ARKai_T.ttf";

-- �������Լ������� ��������
--	local YOUR_FONT_STYLE = CLEAR_FONT_BASE .. "YourFontName.ttf";


-- -----------------------------------------------------------------------------
-- ȫ�����������������������������嶼̫���̫Сʱ�������������
--  ���������������������С��80%����ô���Խ�"1.0"�ĳ�"0.8"
-- -----------------------------------------------------------------------------

	local CF_SCALE = 1.1


-- -----------------------------------------------------------------------------
-- �����ڵ����岢�ı�����
-- -----------------------------------------------------------------------------

	local function CanSetFont(object) 
	   return (type(object)=="table" 
		   and object.SetFont and object.IsObjectType 
		      and not object:IsObjectType("SimpleHTML")); 
	end




-- =============================================================================
--  B. WOW�û��������
-- =============================================================================
--   ����**�޸������С/��Ч**����Ҫ�Ĳ���
--   ��Ҫ�����屻�����г������ಿ�����尴����ĸ��˳������
--   �����г�ֻ���� ClearFont �޸��˵ķ������֣����������з��涼����ʾ��������������Ӱ��
-- -----------------------------------------------------------------------------
--  ������¿��ô���Ľ���
--   �������:		Font:SetFont(SOMETHING_TEXT_FONT, x * scale)
--   ��ͨ���:		Font:SetFont(SOMETHING_TEXT_FONT, x * scale, "OUTLINE")
--   �����:			Font:SetFont(SOMETHING_TEXT_FONT, x * scale, "THICKOUTLINE")
--   ������ɫ:		Font:SetTextColor(r, g, b)
--   ��Ӱ��ɫ:		Font:SetShadowColor(r, g, b) 
--   ��Ӱλ��:		Font:SetShadowOffset(x, y) 
--   ͸����:			Font:SetAlpha(x)
--
--  ������			SetFont(CLEAR_FONT, 13 * CF_SCALE)
--   ��������ĵ�һ������(A.)����������������ţ��ڶ������������С
-- =============================================================================


	function ClearFont:ApplySystemFonts()


-- -----------------------------------------------------------------------------
-- ������Ϸ�����"3D"���壨Dark Imakuni��
--  ***ע��*** ClearFont ���ܶ�����Щ����Ĵ�С����Ч�������BlizzardĬ����Ϸ��ܣ�
-- -----------------------------------------------------------------------------
--  ��Щ����������Ĭ���Ŷӿ�ܡ�����MT/MA��ʱ��������
--  ����㲻�õ�������MT/MA�������Ա�����Щ����䣬�������κ����⣡
--  ������Щ���ķ������ڶ�Ӧ����**����**���ϡ�--��
--   ������--	STANDARD_TEXT_FONT = CLEAR_FONT_CHAT;
-- -----------------------------------------------------------------------------

-- ��������
	STANDARD_TEXT_FONT = CLEAR_FONT_CHAT;

-- ͷ���ϵ����֣�Ư���ı���Զ�����ɿ�����
	UNIT_NAME_FONT = CLEAR_FONT;

-- ͷ���ϵ����֣����������ϣ�NamePlate������V���῿��Ŀ�꣬���ֵ�Ѫ����
	NAMEPLATE_FONT = CLEAR_FONT;

-- ������Ŀ���Ϸ��������˺�ָʾ������SCT/DCT�޹أ�
	DAMAGE_TEXT_FONT = CLEAR_FONT_DAMAGE;


-- ----------------------------------------------------------------------------- 
-- �������ܱ������С��Note by Kirkburn��
--  ***ע��*** ClearFont ֻ�ܶ����������Ĵ�С�������BlizzardĬ����Ϸ��ܣ�
-- ----------------------------------------------------------------------------- 
--  ��Щ����������Ĭ���Ŷӿ�ܡ�����MT/MA��ʱ��������
--  ����㲻�õ�������MT/MA�������Ա�����Щ����䣬�������κ����⣡
--  ������Щ���ķ������ڶ�Ӧ����**����**���ϡ�--��
--   ������--	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12 * CF_SCALE;
-- ----------------------------------------------------------------------------- 

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 13 * CF_SCALE;


-- -----------------------------------------------------------------------------
-- ְҵɫ�ʣ����¾�ΪԤ��ֵ/Ĭ�����֣�
-- -----------------------------------------------------------------------------

--	RAID_CLASS_COLORS = {
--		["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },			-- ����
--		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },			-- ��ʿ
--		["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },				-- ��ʦ
--		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },			-- ʥ��ʿ
--		["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },				-- ��ʦ
--		["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },			-- Ǳ����
--		["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },			-- ��³��
--		["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0 },			-- ����
--		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 }			-- սʿ
--		["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },	-- ������ʿ
--	};


-- -----------------------------------------------------------------------------
-- ϵͳ���壨���¾�ΪԤ��ֵ/Ĭ�����֣�
-- ����������ϵͳ����ģ�棬��Ҫ��������������̳У�New in WotLK/3.x��
-- -----------------------------------------------------------------------------

--	SystemFont_Tiny:SetFont(CLEAR_FONT, 9 * CF_SCALE)
	
--	SystemFont_Small:SetFont(CLEAR_FONT, 10 * CF_SCALE)
	
--	SystemFont_Outline_Small:SetFont(CLEAR_FONT_CHAT, 12 * CF_SCALE, "OUTLINE")

--	SystemFont_Outline:SetFont(CLEAR_FONT_CHAT, 15 * CF_SCALE)
	
--	SystemFont_Shadow_Small:SetFont(CLEAR_FONT, 15 * CF_SCALE)
--	SystemFont_Shadow_Small:SetShadowColor(0, 0, 0) 
--	SystemFont_Shadow_Small:SetShadowOffset(1, -1) 

--	SystemFont_InverseShadow_Small:SetFont(CLEAR_FONT, 10 * CF_SCALE)
--	SystemFont_InverseShadow_Small:SetShadowColor(0.4, 0.4, 0.4) 
--	SystemFont_InverseShadow_Small:SetShadowOffset(1, -1) 
--	SystemFont_InverseShadow_Small:SetAlpha(0.75)
	
--	SystemFont_Med1:SetFont(CLEAR_FONT, 13 * CF_SCALE)

--	SystemFont_Shadow_Med1:SetFont(CLEAR_FONT, 15 * CF_SCALE)
--	SystemFont_Shadow_Med1:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Med1:SetShadowOffset(1, -1) 
	
--	SystemFont_Med2:SetFont(CLEAR_FONT_DAMAGE, 14 * CF_SCALE)

--	SystemFont_Shadow_Med2:SetFont(CLEAR_FONT, 16 * CF_SCALE)
--	SystemFont_Shadow_Med2:SetShadowColor(0, 0, 0) 
--	SystemFont_Shadow_Med2:SetShadowOffset(1, -1) 
	
--	SystemFont_Med3:SetFont(CLEAR_FONT_DAMAGE, 13 * CF_SCALE)
	
--	SystemFont_Shadow_Med3:SetFont(CLEAR_FONT_DAMAGE, 15 * CF_SCALE)
--	SystemFont_Shadow_Med3:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Med3:SetShadowOffset(1, -1) 
	
--	SystemFont_Large:SetFont(CLEAR_FONT, 13 * CF_SCALE)
	
--	SystemFont_Shadow_Large:SetFont(CLEAR_FONT, 17 * CF_SCALE)
--	SystemFont_Shadow_Large:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Large:SetShadowOffset(1, -1) 
	
--	SystemFont_Huge1:SetFont(CLEAR_FONT, 20 * CF_SCALE)

--	SystemFont_Shadow_Huge1:SetFont(CLEAR_FONT, 20 * CF_SCALE)
--	SystemFont_Shadow_Huge1:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Huge1:SetShadowOffset(1, -1) 
	
--	SystemFont_OutlineThick_Huge2:SetFont(CLEAR_FONT, 22 * CF_SCALE, "THICKOUTLINE")
	
--	SystemFont_Shadow_Outline_Huge2:SetFont(CLEAR_FONT, 25 * CF_SCALE, "OUTLINE")
--	SystemFont_Shadow_Outline_Huge2:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Outline_Huge2:SetShadowOffset(2, -2)
	
--	SystemFont_Shadow_Huge3:SetFont(CLEAR_FONT, 25 * CF_SCALE)
--	SystemFont_Shadow_Huge3:SetTextColor(0, 0, 0)
--	SystemFont_Shadow_Huge3:SetShadowOffset(1, -1) 
	
--	SystemFont_OutlineThick_Huge4:SetFont(CLEAR_FONT, 26 * CF_SCALE, "THICKOUTLINE")
	
--	SystemFont_OutlineThick_WTF:SetFont(CLEAR_FONT_CHAT, 112 * CF_SCALE, "THICKOUTLINE")
	
--	ReputationDetailFont:SetFont(CLEAR_FONT, 13 * CF_SCALE)
--	ReputationDetailFont:SetTextColor(1, 1, 1)
--	ReputationDetailFont:SetShadowColor(0, 0, 0) 
--	ReputationDetailFont:SetShadowOffset(1, -1) 

--	FriendsFont_Normal:SetFont(CLEAR_FONT, 15 * CF_SCALE)
--	FriendsFont_Normal:SetShadowColor(0, 0, 0) 
--	FriendsFont_Normal:SetShadowOffset(1, -1) 

--	FriendsFont_Large:SetFont(CLEAR_FONT, 17 * CF_SCALE)
--	FriendsFont_Large:SetShadowColor(0, 0, 0) 
--	FriendsFont_Large:SetShadowOffset(1, -1) 

--	FriendsFont_UserText:SetFont(CLEAR_FONT_CHAT, 11 * CF_SCALE)
--	FriendsFont_UserText:SetShadowColor(0, 0, 0) 
--	FriendsFont_UserText:SetShadowOffset(1, -1) 

--	GameFont_Gigantic:SetFont(CLEAR_FONT, 41 * CF_SCALE)
--	GameFont_Gigantic:SetShadowColor(0, 0, 0) 
--	GameFont_Gigantic:SetShadowOffset(1, -1) 
--	GameFont_Gigantic:SetTextColor(1.0, 0.82, 0)


-- -----------------------------------------------------------------------------
-- ����Ϸ����: �洦�ɼ�����Ҫ������
-- -----------------------------------------------------------------------------

-- �����⣬��ť�����ܱ��⣨��������壩����������������־��壩�����ѽ�ɫ���֣��罻��壩������������������������PvP��壩��ϵͳ���ܱ�ר��
	if (CanSetFont(GameFontNormal)) then 				GameFontNormal:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- Ԥ��ֵ��15
   
-- �����⣬ϵͳ���ܱ�ť���ɾ͵������ɾ���Ŀ���ɾ���壩�����������Ŀ��������������������־��壩����������
	if (CanSetFont(GameFontHighlight)) then 			GameFontHighlight:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- Ԥ��ֵ��15

-- ��δȷ�ϣ�
	if (CanSetFont(GameFontNormalMed3)) then 			GameFontNormalMed3:SetFont(CLEAR_FONT, 13 * CF_SCALE); end	-- Ԥ��ֵ��14
	if (CanSetFont(GameFontNormalMed3)) then 			GameFontNormalMed3:SetTextColor(1.0, 0.82, 0); end	-- Ԥ��ֵ��(1.0, 0.82, 0)

-- ��ť������ѡ״̬��
	if (CanSetFont(GameFontDisable)) then 				GameFontDisable:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
	if (CanSetFont(GameFontDisable)) then 				GameFontDisable:SetTextColor(0.5, 0.5, 0.5); end	-- Ԥ��ֵ��(0.5, 0.5, 0.5)

-- ����ɫ������
	if (CanSetFont(GameFontGreen)) then 				GameFontGreen:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- Ԥ��ֵ��15
	if (CanSetFont(GameFontRed)) then 					GameFontRed:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
	if (CanSetFont(GameFontBlack)) then 				GameFontBlack:SetFont(CLEAR_FONT, 14 * CF_SCALE); end
	if (CanSetFont(GameFontWhite)) then 				GameFontWhite:SetFont(CLEAR_FONT, 14 * CF_SCALE); end


-- -----------------------------------------------------------------------------
-- С���壺������С����ĵط������ɫ������壬BUFFʱ�䣬�����
-- -----------------------------------------------------------------------------

-- ͷ�������֣�BUFFʱ�䣬δѡ�������ǩ������д󲿷��������壬�츳�����λ��ͷ�ν������ɾ���壩����ѯ�������Ա��ɫ���֣��罻��壩��
-- ������վ����ϸ��վ�ӵȼ���PvP��壩���������Ŀ
	if (CanSetFont(GameFontNormalSmall)) then 			GameFontNormalSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end		-- Ԥ��ֵ��15

-- �������壬�������ܱ�ѡ���ѡ�������ǩ����ɫ���ԡ����ܵ���λ��������Ŀ����ɫ��Ѷ��壩���츳�������츳��壩����ɫ�ȼ���ְҵ����Ѷ��������Ѷ���罻��壩��
-- ��ϸ�����㡢�������ȷ֣�PvP��壩��ʱ����Ѷ��ϵͳ���ܱ���ר��
	if (CanSetFont(GameFontHighlightSmall)) then 		GameFontHighlightSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ԥ��ֵ��15
	if (CanSetFont(GameFontHighlightSmallOutline)) then	GameFontHighlightSmallOutline:SetFont(CLEAR_FONT, 12 * CF_SCALE, "OUTLINE"); end

-- PvP����������Ŷ���尴ť��
	if (CanSetFont(GameFontDisableSmall)) then			GameFontDisableSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ԥ��ֵ��15
	if (CanSetFont(GameFontDisableSmall)) then			GameFontDisableSmall:SetTextColor(0.5, 0.5, 0.5); end	-- Ԥ��ֵ��(0.5, 0.5, 0.5)

-- ��δȷ�ϣ�
	if (CanSetFont(GameFontDarkGraySmall)) then 		GameFontDarkGraySmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ԥ��ֵ��15
	if (CanSetFont(GameFontDarkGraySmall)) then 		GameFontDarkGraySmall:SetTextColor(0.35, 0.35, 0.35); end	-- Ԥ��ֵ��(0.35, 0.35, 0.35)

-- ��δȷ�ϣ�
	if (CanSetFont(GameFontGreenSmall)) then 			GameFontGreenSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end	-- Ԥ��ֵ��15
	if (CanSetFont(GameFontRedSmall)) then				GameFontRedSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE); end
	
-- ��С����
	if (CanSetFont(GameFontHighlightExtraSmall)) then 		GameFontHighlightExtraSmall:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ԥ��ֵ��15


-- -----------------------------------------------------------------------------
-- �����壺����
-- -----------------------------------------------------------------------------

-- ʱ�ӣ����
	if (CanSetFont(GameFontNormalLarge)) then 			GameFontNormalLarge:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- Ԥ��ֵ��17
	if (CanSetFont(GameFontHighlightLarge)) then 		GameFontHighlightLarge:SetFont(CLEAR_FONT, 13 * CF_SCALE); end

-- ���������
	if (CanSetFont(GameFontDisableLarge)) then			GameFontDisableLarge:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- Ԥ��ֵ��17
	if (CanSetFont(GameFontDisableLarge)) then			GameFontDisableLarge:SetTextColor(0.5, 0.5, 0.5); end	-- Ԥ��ֵ��(0.5, 0.5, 0.5)

-- ��δȷ�ϣ�
	if (CanSetFont(GameFontGreenLarge)) then 			GameFontGreenLarge:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- Ԥ��ֵ��17
	if (CanSetFont(GameFontRedLarge)) then 			GameFontRedLarge:SetFont(CLEAR_FONT, 14 * CF_SCALE); end


-- -----------------------------------------------------------------------------
-- �޴����壺Raid����
-- -----------------------------------------------------------------------------

	if (CanSetFont(GameFontNormalHuge)) then			GameFontNormalHuge:SetFont(CLEAR_FONT, 20 * CF_SCALE); end	-- Ԥ��ֵ��20
	if (CanSetFont(GameFontNormalHugeBlack)) then		GameFontNormalHugeBlack:SetFont(CLEAR_FONT, 20 * CF_SCALE); end	-- Ԥ��ֵ��20


-- -----------------------------------------------------------------------------
-- Boss��������
-- -----------------------------------------------------------------------------

	if (CanSetFont(BossEmoteNormalHuge)) then			BossEmoteNormalHuge:SetFont(CLEAR_FONT, 25 * CF_SCALE); end		-- Ԥ��ֵ��25

-- -----------------------------------------------------------------------------
-- ��λ����: �����У���ң������󶨣���Ʒ�ѵ�����
-- -----------------------------------------------------------------------------

-- ��ң���Ʒ��Buff�ѵ�����
	if (CanSetFont(NumberFontNormal)) then				NumberFontNormal:SetFont(CLEAR_FONT_NUMBER, 12 * CF_SCALE, "OUTLINE"); end		-- Ԥ��ֵ��12
	if (CanSetFont(NumberFontNormalYellow)) then 		NumberFontNormalYellow:SetFont(CLEAR_FONT_NUMBER, 12 * CF_SCALE); end

-- �������İ�����
	if (CanSetFont(NumberFontNormalSmall)) then 		NumberFontNormalSmall:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "OUTLINE"); end		-- Ԥ��ֵ��11
	if (CanSetFont(NumberFontNormalSmallGray)) then 	NumberFontNormalSmallGray:SetFont(CLEAR_FONT_NUMBER, 11 * CF_SCALE, "THICKOUTLINE"); end

-- ��δȷ�ϣ�
	if (CanSetFont(NumberFontNormalLarge)) then 		NumberFontNormalLarge:SetFont(CLEAR_FONT_NUMBER, 14 * CF_SCALE, "OUTLINE"); end		-- Ԥ��ֵ��14

-- ���ͷ���ϵı�����ָʾ
	if (CanSetFont(NumberFontNormalHuge)) then			NumberFontNormalHuge:SetFont(CLEAR_FONT_DAMAGE, 20 * CF_SCALE, "THICKOUTLINE"); end	-- Ԥ��ֵ��20
--	if (CanSetFont(NumberFontNormalHuge)) then			NumberFontNormalHuge:SetAlpha(30); end


-- -----------------------------------------------------------------------------
-- �����Ӵ�������������������
-- -----------------------------------------------------------------------------

-- �������������
	if (CanSetFont(ChatFontNormal)) then 				ChatFontNormal:SetFont(CLEAR_FONT_CHAT, 14 * CF_SCALE); end	-- Ԥ��ֵ��14

-- ��ѡ���������
	CHAT_FONT_HEIGHTS = {
		[1] = 7,
		[2] = 8,
		[3] = 9,
		[4] = 10,
		[5] = 11,
		[6] = 12,
		[7] = 13,
		[8] = 14,
		[9] = 15,
		[10] = 16,
		[11] = 17,
		[12] = 18,
		[13] = 19,
		[14] = 20,
		[15] = 21,
		[16] = 22,
		[17] = 23,
		[18] = 24
	};

-- �����Ӵ�Ĭ������
	if (CanSetFont(ChatFontSmall)) then 				ChatFontSmall:SetFont(CLEAR_FONT_CHAT, 13 * CF_SCALE); end	-- Ԥ��ֵ��12


-- -----------------------------------------------------------------------------
-- ������־: ������־���鼮��
-- -----------------------------------------------------------------------------

-- �������
	if (CanSetFont(QuestTitleFont)) then 				QuestTitleFont:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end	-- Ԥ��ֵ��17
	if (CanSetFont(QuestTitleFont)) then 				QuestTitleFont:SetShadowColor(0, 0, 0); end		-- Ԥ��ֵ��(0, 0, 0)

	if (CanSetFont(QuestTitleFontBlackShadow)) then 	QuestTitleFontBlackShadow:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end	-- Ԥ��ֵ��17
	if (CanSetFont(QuestTitleFontBlackShadow)) then 	QuestTitleFontBlackShadow:SetShadowColor(0, 0, 0); end		-- Ԥ��ֵ��(0, 0, 0)
	if (CanSetFont(QuestTitleFontBlackShadow)) then 	QuestTitleFontBlackShadow:SetTextColor(1.0, 0.82, 0); end			-- Ԥ��ֵ��(1.0, 0.82, 0)

-- ��������
	if (CanSetFont(QuestFont)) then 		   			QuestFont:SetFont(CLEAR_FONT_QUEST, 14 * CF_SCALE); end		-- Ԥ��ֵ��14
	if (CanSetFont(QuestFont)) then 		   			QuestFont:SetTextColor(1, 1, 1); end			-- Ԥ��ֵ��(0, 0, 0)

-- ����Ŀ��
	if (CanSetFont(QuestFontNormalSmall)) then			QuestFontNormalSmall:SetFont(CLEAR_FONT, 13 * CF_SCALE); end	-- Ԥ��ֵ��14
	if (CanSetFont(QuestFontNormalSmall)) then			QuestFontNormalSmall:SetShadowColor(0.3, 0.18, 0); end	-- Ԥ��ֵ��(0.3, 0.18, 0)

-- �������
	if (CanSetFont(QuestFontHighlight)) then 			QuestFontHighlight:SetFont(CLEAR_FONT_QUEST, 13 * CF_SCALE); end	-- Ԥ��ֵ��13


-- -----------------------------------------------------------------------------
-- ��Ʒ��Ϣ: ��Щ"���Ҽ��Ķ�"����Ʒ��������Ʒ���������壬�������Я�����鼮���ż��ĸ����ȣ�
-- -----------------------------------------------------------------------------

	if (CanSetFont(ItemTextFontNormal)) then 	 	  	ItemTextFontNormal:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end		-- Ԥ��ֵ��15
	if (CanSetFont(ItemTextFontNormal)) then			ItemTextFontNormal:SetShadowColor(0.18, 0.12, 0.06); end	-- Ԥ��ֵ��(0.18, 0.12, 0.06)


-- -----------------------------------------------------------------------------
-- �ʼ�
-- -----------------------------------------------------------------------------

	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetFont(CLEAR_FONT_QUEST, 15 * CF_SCALE); end	-- Ԥ��ֵ��15
	if (CanSetFont(MailTextFontNormal)) then 		   	MailTextFontNormal:SetTextColor(1, 1, 1); end		-- Ԥ��ֵ��(0.18, 0.12, 0.06)
--	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetShadowColor(0.54, 0.4, 0.1); end
--	if (CanSetFont(MailTextFontNormal)) then 	 	  	MailTextFontNormal:SetShadowOffset(1, -1); end
   
   
-- -----------------------------------------------------------------------------
-- ���ܣ��������ͣ������������س��ȣ������ܵȼ�
-- -----------------------------------------------------------------------------

	if (CanSetFont(SubSpellFont)) then					SubSpellFont:SetFont(CLEAR_FONT_QUEST, 12 * CF_SCALE); end	-- Ԥ��ֵ��12
	if (CanSetFont(SubSpellFont)) then 	   			SubSpellFont:SetTextColor(0.35, 0.2, 0); end	-- Ԥ��ֵ��(0.35, 0.2, 0)


-- -----------------------------------------------------------------------------
-- �Ի����鰴ť��"ͬ��"������
-- -----------------------------------------------------------------------------

	if (CanSetFont(DialogButtonNormalText)) then 		DialogButtonNormalText:SetFont(CLEAR_FONT, 13 * CF_SCALE); end	-- Ԥ��ֵ��13
	if (CanSetFont(DialogButtonHighlightText)) then 	DialogButtonHighlightText:SetFont(CLEAR_FONT, 13 * CF_SCALE); end


-- -----------------------------------------------------------------------------
-- �����л���ʾ����өĻ����֪ͨ
-- -----------------------------------------------------------------------------

-- �������ܱ�������
	if (CanSetFont(ZoneTextFont)) then 	   			ZoneTextFont:SetFont(CLEAR_FONT, 32 * CF_SCALE, "THICKOUTLINE"); end		-- Ԥ��ֵ��112
	if (CanSetFont(ZoneTextFont)) then 	   			ZoneTextFont:SetShadowColor(1.0, 0.9294, 0.7607); end	-- Ԥ��ֵ��(1.0, 0.9294, 0.7607)
	if (CanSetFont(ZoneTextFont)) then 	   			ZoneTextFont:SetShadowOffset(1, -1); end

-- �������ܱ�������
	if (CanSetFont(SubZoneTextFont)) then				SubZoneTextFont:SetFont(CLEAR_FONT, 26 * CF_SCALE, "THICKOUTLINE"); end		-- Ԥ��ֵ��26


-- -----------------------------------------------------------------------------
-- PvP��Ϣ���硰�����е�����������������ء���
-- -----------------------------------------------------------------------------

	if (CanSetFont(PVPInfoTextFont)) then				PVPInfoTextFont:SetFont(CLEAR_FONT, 20 * CF_SCALE, "THICKOUTLINE"); end		-- Ԥ��ֵ��22


-- -----------------------------------------------------------------------------
-- �������壺"��һ���������ڽ�����"������
-- -----------------------------------------------------------------------------

	if (CanSetFont(ErrorFont)) then					ErrorFont:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- Ԥ��ֵ��17
	if (CanSetFont(ErrorFont)) then					ErrorFont:SetShadowOffset(1, -1); end	-- Ԥ��ֵ��(1, -1)


-- -----------------------------------------------------------------------------
-- ״̬����ͷ�����е����֣�����ֵ������ֵ/ŭ��ֵ/����ֵ�ȣ��������������顢�����ȣ�
-- -----------------------------------------------------------------------------

	if (CanSetFont(TextStatusBarText)) then			TextStatusBarText:SetFont(CLEAR_FONT_EXP, 12 * CF_SCALE, "OUTLINE"); end	-- Ԥ��ֵ��12
	if (CanSetFont(TextStatusBarTextLarge)) then		TextStatusBarTextLarge:SetFont(CLEAR_FONT_EXP, 14 * CF_SCALE, "OUTLINE"); end	-- Ԥ��ֵ��15
	

-- -----------------------------------------------------------------------------
-- ս����¼����
-- -----------------------------------------------------------------------------

	if (CanSetFont(CombatLogFont)) then				CombatLogFont:SetFont(CLEAR_FONT, 14 * CF_SCALE); end	-- Ԥ��ֵ��16


-- -----------------------------------------------------------------------------
-- ��ʾ��ToolTip��
-- -----------------------------------------------------------------------------

-- ��ʾ������
	if (CanSetFont(GameTooltipText)) then				GameTooltipText:SetFont(CLEAR_FONT_ITEM, 13 * CF_SCALE); end		-- Ԥ��ֵ��13
   
-- װ���Ƚϵ�С�ֲ���
	if (CanSetFont(GameTooltipTextSmall)) then			GameTooltipTextSmall:SetFont(CLEAR_FONT_ITEM, 12 * CF_SCALE); end	-- Ԥ��ֵ��12

-- ��ʾ�����
	if (CanSetFont(GameTooltipHeaderText)) then		GameTooltipHeaderText:SetFont(CLEAR_FONT, 15 * CF_SCALE, "OUTLINE"); end	-- Ԥ��ֵ��16


-- -----------------------------------------------------------------------------
-- �����ͼ��λ�ñ���
-- -----------------------------------------------------------------------------

	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetFont(CLEAR_FONT, 102 * CF_SCALE, "THICKOUTLINE"); end	-- Ԥ��ֵ��102
	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetShadowColor(1.0, 0.9294, 0.7607); end	-- Ԥ��ֵ��(1.0, 0.9294, 0.7607)
	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetShadowOffset(1, -1); end
--	if (CanSetFont(WorldMapTextFont)) then				WorldMapTextFont:SetAlpha(0.4); end


-- -----------------------------------------------------------------------------
-- ���������������ʼ����ķ�����
-- -----------------------------------------------------------------------------

	if (CanSetFont(InvoiceTextFontNormal)) then 	   	InvoiceTextFontNormal:SetFont(CLEAR_FONT_QUEST, 13 * CF_SCALE); end	-- Ԥ��ֵ��12
	if (CanSetFont(InvoiceTextFontNormal)) then 	   	InvoiceTextFontNormal:SetTextColor(1, 1, 1); end	-- Ԥ��ֵ��(0.18, 0.12, 0.06)

	if (CanSetFont(InvoiceTextFontSmall)) then			InvoiceTextFontSmall:SetFont(CLEAR_FONT_QUEST, 11 * CF_SCALE); end	-- Ԥ��ֵ��10
	if (CanSetFont(InvoiceTextFontSmall)) then			InvoiceTextFontSmall:SetTextColor(1, 1, 1); end	-- Ԥ��ֵ��(0.18, 0.12, 0.06)


-- -----------------------------------------------------------------------------
-- ս������: ��ѩ����ս��ָʾ��
-- -----------------------------------------------------------------------------

	if (CanSetFont(CombatTextFont)) then				CombatTextFont:SetFont(CLEAR_FONT_DAMAGE, 25 * CF_SCALE); end		-- Ԥ��ֵ��25


-- -----------------------------------------------------------------------------
-- ӰƬ��Ļ���֣�New in WotLK/3.x��
-- -----------------------------------------------------------------------------

	if (CanSetFont(MovieSubtitleFont)) then			MovieSubtitleFont:SetFont(CLEAR_FONT, 25 * CF_SCALE); end		-- Ԥ��ֵ��25
	if (CanSetFont(MovieSubtitleFont)) then			MovieSubtitleFont:SetTextColor(1.0, 0.78, 0); end	-- Ԥ��ֵ��(1.0, 0.78, 0)


-- -----------------------------------------------------------------------------
-- �ɾ�ϵͳ��New in WotLK/3.x��
-- -----------------------------------------------------------------------------

-- �ɾ�ϵͳ��������ϵĳɾͷ���
	if (CanSetFont(AchievementPointsFont)) then		AchievementPointsFont:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- Ԥ��ֵ��13

-- �ɾ�ϵͳ�ܻ����ĳɾͷ���
	if (CanSetFont(AchievementPointsFontSmall)) then	AchievementPointsFontSmall:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- Ԥ��ֵ��13

-- �ɾ�ϵͳ����������
	if (CanSetFont(AchievementDescriptionFont)) then	AchievementDescriptionFont:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- Ԥ��ֵ��13

-- �ɾ�ϵͳ�����ĸ�����
	if (CanSetFont(AchievementCriteriaFont)) then		AchievementCriteriaFont:SetFont(CLEAR_FONT, 13 * CF_SCALE); end		-- Ԥ��ֵ��13
   
-- �ɾ�ϵͳ��¼������
	if (CanSetFont(AchievementDateFont)) then			AchievementDateFont:SetFont(CLEAR_FONT, 11 * CF_SCALE); end		-- Ԥ��ֵ��13


-- -----------------------------------------------------------------------------
-- ����ˡ�����ϵͳ��أ���ȷ�ϣ�New in WotLK/3.2+��
-- -----------------------------------------------------------------------------

	if (CanSetFont(VehicleMenuBarStatusBarText)) then		VehicleMenuBarStatusBarText:SetFont(CLEAR_FONT, 15 * CF_SCALE); end		-- Ԥ��ֵ��15
	if (CanSetFont(VehicleMenuBarStatusBarText)) then		VehicleMenuBarStatusBarText:SetTextColor(1.0, 1.0, 1.0); end	-- Ԥ��ֵ��(1.0, 1.0, 1.0)


-- -----------------------------------------------------------------------------
-- ���������壨��ȷ�ϣ�New in CTM/4.0+��
-- -----------------------------------------------------------------------------

	if (CanSetFont(FocusFontSmall)) then				FocusFontSmall:SetFont(CLEAR_FONT, 15 * CF_SCALE); end		-- Ԥ��ֵ��16


	end




-- =============================================================================
--  C. ÿ��һ���������ʱ����������Ĺ���
--  ������ϲ�������ҵĲ����
-- =============================================================================

	ClearFont:SetScript("OnEvent",
			function() 
				if (event == "ADDON_LOADED") then
					ClearFont:ApplySystemFonts()
				end
			end);

	ClearFont:RegisterEvent("ADDON_LOADED");




-- =============================================================================
--  D. ��һ������ʱӦ�������趨
--  �����ܹ�������
-- =============================================================================

	ClearFont:ApplySystemFonts()
