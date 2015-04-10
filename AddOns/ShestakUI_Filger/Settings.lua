-- ����(���ε��� λ��,ͼ���С��, �������¥�ö��ı�עͼ)
Filger_Settings = {
	config_mode = false,				-- ��\�ز���ģʽ
	max_test_icon = 5,					-- ����ģʽ��,ÿ����ʾ���ͼ������
	player_buff_icon = {"BOTTOMRIGHT", UIParent, "CENTER", -200, 50},		-- "P_BUFF_ICON"		(player_buff_icon λ������ - ��ͼ��ע�� 1)
	player_proc_icon = {"BOTTOMLEFT", UIParent, "CENTER", 200, 50},		-- "P_PROC_ICON"		(player_proc_icon λ������ - ��ͼ��ע�� 2)
	special_proc_icon = {"BOTTOMRIGHT", UIParent, "CENTER", -200, 90},	-- "SPECIAL_P_BUFF_ICON"	(special_proc_icon λ������ - ��ͼ��ע�� 3)
	target_debuff_icon = {"BOTTOMLEFT", UIParent, "CENTER", 200, 90},	-- "T_DEBUFF_ICON"		(target_debuff_icon λ������ - ��ͼ��ע�� 4)
	target_buff_icon = {"BOTTOMLEFT", UIParent, "CENTER", 200, 130},		-- "T_BUFF"				(target_buff_icon λ������ - ��ͼ��ע�� 5)
	pve_debuff = {"BOTTOMRIGHT", UIParent, "CENTER", -200, 130},			-- "PVE/PVP_DEBUFF"	(pve_debuff λ������ - ��ͼ��ע�� 6)
	pve_cc = {"TOPLEFT", UIParent, "LEFT", 50, 0},								-- "PVE/PVP_CC"			(pve_cc λ������ - ��ͼ��ע�� 7)
	cooldown = {"TOPLEFT", UIParent, "CENTER", -90, -80},					-- "COOLDOWN"			(cooldown λ������ - ��ͼ��ע�� 8)
	target_bar = {"BOTTOMLEFT", UIParent, "CENTER", 120, -150},						-- "T_DE/BUFF_BAR"
}

local Misc = CreateFrame("Frame")
local Media = "Interface\\AddOns\\ShestakUI_Filger\\Media\\"
	Misc.Media = Media

	-- ShestakUI_Filger.lua
	-- ��ѡ��ɫ: "DK", "DLY"-С��, "LR", "FS", "WS"-��ɮ, "QS", "MS"-��ʦ(�Ȱ�ɫ), "DZ", "SM", "SS", "ZS", "Black"-��ɫ, "Gray"-��ɫ, "OWN"-�Զ�ѡ���㵱ǰ��ɫ��ְҵ��ɫ.
	Misc.font = Media.."Pixel.ttf"	-- �������ֵ�����
	Misc.barfg = Media.."White"		-- ��ʱ������
	Misc.modefg = "OWN"				-- ��ʱ����ɫ
--	Misc.modeback = "OWN"			-- ͼ�걳�����ɰ���ɫ��һ���غ�ë������ʽ��Ч��
	Misc.modeborder = "Black"		-- �߿���ɫ
	Misc.numsize = 14				-- ����, ��ʱ���ļ�ʱ���ִ�С
	Misc.namesize = 14				-- �������������С

	-- Cooldowns.lua
	Misc.cdsize = 16				-- ͼ���м�� CD ���ִ�С

	-- Spells.lua
	Misc.Tbar = "OFF"				-- ��(ON)\��(OFF) target_bar Ŀ���ʱ�� - (��ͼ��ע�� 9)
	Misc.Pbar = "OFF"				-- ��(ON)\��(OFF) pve_cc ��ʱ�� - (��ͼ��ע�� 7)
	Misc.CD = "OFF"					-- ��(ON)\��(OFF) COOLDOWN ��ȴͼ�� - (��ͼ��ע�� 8)
	Misc.barw = 160					-- ��ʱ������ - (��ͼ��ע�� 7,9)
	Misc.CDnum = 6					-- COOLDOWN ��ȴͼ��ÿ����ʾ���� - (��ͼ��ע�� 8)
	Misc.IconSize = 38				-- ͼ���С - (��ͼ��ע�� 1,2,3,4,5,6)
	Misc.CDIconSize = 31			-- COOLDOWN ��ȴͼ���С - (��ͼ��ע�� 8)
	Misc.barIconSize = 25			-- ��ʱ���ϵ�ͼ���С - (��ͼ��ע�� 7,9)
	
-------------------------------------------------------- 
getscreenheight = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")) 
getscreenwidth = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x+%d")) 

--   Pixel perfect script of custom ui Scale 
UIScale = function() 
   uiscale = min(2, max(0.64, 768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)"))) 
end 
UIScale() 

local mult = 768 / string.match(GetCVar("gxResolution"), "%d+x(%d+)") / uiscale 
local Scale = function(x) 
   return mult * math.floor(x / mult + 0.5) 
end 
Misc.mult = mult 

----------------------- ShestakUI_Filger_1px -----------------------

-- �����ռ�
local _, sakaras = ...
sakaras.FilgerSettings = Misc
