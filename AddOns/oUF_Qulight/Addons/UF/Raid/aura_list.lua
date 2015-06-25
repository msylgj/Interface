	do
		local ORD = oUF_RaidDebuffs

		if not ORD then return end
		
		ORD.ShowDispelableDebuff = true
		ORD.FilterDispellableDebuff = true
		ORD.MatchBySpellName = true
		ORD.DeepCorruption = true
		
		local function SpellName(id)
			local name = select(1, GetSpellInfo(id))
			return name	
		end

		debuffids = {
			-------------------------------<<  PVE  >>-------------------------------

			-- 心智 [尤格萨隆]
			SpellName(63050),
			
			----------------------------------WOD------------------------------------
			-- 地狱火堡垒 --
			--奇袭地狱火
			SpellName(186016),  --邪火弹药
			SpellName(184379),  --啸风战斧
			SpellName(184238),  --颤抖！
			SpellName(184243),  --猛击
			SpellName(185806),  --导电冲击脉冲
			SpellName(180022),  --钻孔
			SpellName(185157),  --灼烧
			SpellName(187655),  --腐化虹吸
			--钢铁掠夺者
			SpellName(182074),  --献祭
			SpellName(182001),  --不稳定的宝珠
			SpellName(182280),  --炮击
			SpellName(182003),  --燃料尾痕
			SpellName(179897/185242),  --迅猛突袭
			SpellName(185978),  --易爆火焰炸弹
			--考莫克
			SpellName(181345),  --攫取之手
			SpellName(181321),  --邪能之触
			SpellName(181306),  --爆裂冲击
			SpellName(187819),  --邪污碾压
			SpellName(180270),  --暗影血球
			SpellName(185519),  --炽热血球
			SpellName(185521),  --邪污血球
			SpellName(181082),  --暗影之池
			SpellName(186559),  --火焰之池
			SpellName(186560),  --邪污之池
			SpellName(181208),  --暗影残渣
			SpellName(185686),  --爆炸残渣
			SpellName(185687),  --邪恶残渣
			--地狱火高阶议会
			SpellName(184449),  --死灵印记紫
			SpellName(184450),  --死灵印记紫
			SpellName(184676),  --死灵印记紫
			SpellName(185065),  --死灵印记黄
			SpellName(185066),  --死灵印记红
			SpellName(184360),  --堕落狂怒
			SpellName(184847),  --酸性创伤
			SpellName(184652),  --暗影收割
			SpellName(184357),  --污血
			SpellName(184355),  --血液沸腾
			--基爾羅格‧亡眼
			SpellName(188929),  --剖心飞刀
			SpellName(180389),  --剖心飞刀
			SpellName(182159),  --邪能腐蚀
			SpellName(184396),  --邪能腐蚀
			SpellName(180313),  --恶魔附身
			SpellName(180718),  --永恒的决心
			SpellName(181488),  --死亡幻象
			SpellName(185563),  --永恒的救赎
			SpellName(180200),  --碎甲
			SpellName(180575),  --邪能烈焰
			SpellName(183917),  --撕裂嚎叫
			SpellName(188852),  --溅血
			SpellName(184067),  --邪能腐液
			--血魔
			SpellName(180093),  --灵魂箭雨
			SpellName(179864),  --死亡之影
			SpellName(179867),  --血魔的腐化
			SpellName(181295),  --消化
			SpellName(180148),  --生命渴望
			SpellName(179977),  --毁灭之触
			SpellName(179995),  --末日井
			SpellName(185189),  --邪能之怒
			SpellName(179908),  --命运相连
			SpellName(179909),  --命运相连
			SpellName(186770),  --灵魂之池
			--暗影領主伊斯卡
			SpellName(185239),  --安苏之光
			SpellName(182325),  --幻影之伤
			SpellName(182600),  --邪能焚化
			SpellName(181957),  --幻影之风
			SpellName(182200/182178),  --邪能飞轮
			SpellName(179219),  --幻影邪能炸弹
			SpellName(181753),  --邪能炸弹
			SpellName(181824),  --幻影腐蚀
			SpellName(187344),  --幻影焚化
			SpellName(185456),  --绝望之链
			SpellName(185510),  --暗影之缚
			--永恆者索奎薩爾
			SpellName(182038),  --粉碎防御
			SpellName(189627),  --易爆的邪能宝珠
			SpellName(182218),  --邪炽残渣
			SpellName(180415),  --邪能牢笼
			SpellName(189540),  --压倒能量
			SpellName(190466),  --低同步率
			SpellName(184124),  --堕落者之赐
			SpellName(182769),  --魅影重重
			SpellName(184239),  --暗言术：恶
			SpellName(182900),  --恶毒鬼魅
			SpellName(188666),  --无尽饥渴
			SpellName(190776),  --索克雷萨之咒
			--女暴君維哈里
			SpellName(180000),  --凋零契印
			SpellName(179987),  --蔑视光环
			SpellName(181683),  --抑制光环
			SpellName(179993),  --怨恨光环
			SpellName(180526),  --腐蚀序列
			SpellName(180166/180164),  --裂伤之触
			SpellName(182459),  --谴责法令
			SpellName(180604),  --亵渎之地
			--惡魔領主札昆
			SpellName(189260),  --破碎之魂
			SpellName(179407),  --魂不附体
			SpellName(182008),  --潜伏能量
			SpellName(189032),  --玷污绿
			SpellName(189031),  --玷污黄
			SpellName(189030),  --玷污红橙
			SpellName(179428),  --轰鸣的裂隙
			SpellName(181508),  --毁灭之种
			SpellName(181515),  --毁灭之种
			SpellName(181653),  --邪能水晶
			SpellName(188998),  --枯竭灵魂
			--祖霍拉克
			SpellName(186134),  --邪蚀
			SpellName(186135),  --灵媒
			SpellName(185656),  --邪影屠戮
			SpellName(186073),  --邪能炙烤
			SpellName(186063),  --虚空消耗
			SpellName(186407),  --魔能喷涌
			SpellName(186333),  --灵能涌动
			SpellName(186448),  --邪焰乱舞
			SpellName(186453),  --邪焰乱舞
			SpellName(186785),  --凋零凝视
			SpellName(186783),  --凋零凝视
			SpellName(188208),  --点燃
			SpellName(186547),  --黑洞
			SpellName(186500),  --邪能锁链
			SpellName(189775),  --强化邪能锁链
			--瑪諾洛斯
			SpellName(181275),  --军团诅咒
			SpellName(181099),  --末日印记
			SpellName(181119),  --末日之刺
			SpellName(189717),  --末日之刺
			SpellName(182171),  --玛洛诺斯之血
			SpellName(184252),  --穿刺之伤
			SpellName(191231),  --穿刺之伤
			SpellName(181359),  --巨力冲击
			SpellName(181597),  --玛诺洛斯凝视
			SpellName(181841),  --暗影之力
			SpellName(182006),  --强化玛诺洛斯凝视
			SpellName(182088),  --强化暗影之力
			SpellName(182031),  --凝视暗影
			SpellName(190482),  --束缚暗影
			--阿克蒙德
			SpellName(183634),  --暗影冲击
			SpellName(187742),  --暗影冲击
			SpellName(183864),  --暗影冲击
			SpellName(183828),  --死亡烙印
			SpellName(183586),  --魔火
			SpellName(182879),  --魔火锁定
			SpellName(183963),  --纳鲁之光
			SpellName(185014),  --聚焦混乱
			SpellName(186123),  --精炼混乱
			SpellName(184964),  --枷锁酷刑
			SpellName(186952),  --虚空放逐
			SpellName(186961),  --虚空放逐
			SpellName(187047),  --吞噬生命
			SpellName(189891),  --虚空撕裂
			SpellName(190049),  --虚空腐化
			SpellName(188796),  --邪能腐蚀

			-- 黑石要塞
			-- 1	格鲁尔 [Gruul]
			SpellName(155326),
			
			-- 2	奥尔高格 [Oregorger]
			SpellName(156324),
			
			-- 3	兽王达玛克 [Beastlord Darmac]
			SpellName(155365),
			SpellName(155399),
			SpellName(154989),
			SpellName(155499),
			
			-- 4	缚火者卡格拉兹 [Flamebender Ka'graz]
			SpellName(155277),
			
			-- 5	汉斯加尔与弗兰佐克 [Hans'gar and Franzok]
			SpellName(157139),
			
			-- 6	主管索格尔 [Operator Thogar]
			SpellName(155921),
			
			-- 7	爆裂熔炉 [The Blast Furnace]
			SpellName(155240),
			SpellName(155242),
			
			-- 8	克罗莫格 [Kromog]
			SpellName(157060),
			
			-- 9	钢铁女武神 [The Iron Maidens]
			SpellName(158315),
			
			-- 10	黑手 [Blackhand]
			SpellName(156096),
			
			--  [970]  悬槌堡
			-- 0   小怪
			-- 污染之爪
			SpellName(175601),
			-- 剧毒辐射
			SpellName(172069),
			-- 毁灭符文
			SpellName( 56037),
			-- 瓦解符文
			SpellName(175654),
			-- 冰冻核心
			SpellName(174404),
			-- 野火
			SpellName(173827),
			-- 熔火炸弹
			SpellName(161635),

			-- 1   卡加斯.刃拳
			-- 烈焰喷射
			SpellName(159311),
			-- 抓钩
			SpellName(159188),
			-- 狂暴冲锋
			SpellName(158986),
			-- 钢铁炸弹
			SpellName(159386),
			-- 迸裂创伤 (仅坦克)
			SpellName(159178),
			-- 穿刺 (DoT)
			SpellName(159113),
			-- 锁链投掷
			SpellName(159947),
			-- 暴虐酒
			SpellName(159413),
			-- 邪恶吐息
			SpellName(160521),
			-- 搜寻猎物
			SpellName(162497),

			-- 2   屠夫
			-- 捶肉槌
			SpellName(156151),
			-- 龟裂创伤
			SpellName(156152),
			-- 切肉刀
			SpellName(156143),
			-- 白鬼硫酸
			SpellName(163046),

			-- 3   泰克图斯
			-- 晶化弹幕
			SpellName(162346),
			SpellName(162370),
			-- 石化
			SpellName(162892),

			-- 4   布兰肯斯波
			-- 感染孢子
			SpellName(163242),
			-- 蚀脑真菌
			SpellName(160179),
			-- 死疽吐息
			SpellName(159220),
			-- 脉冲高热
			SpellName(163666),
			-- 溃烂
			SpellName(163241),
			-- 滑溜溜的苔藓
			SpellName(163590),

			-- 5   独眼魔双子
			-- 致衰咆哮
			SpellName(158026),
			-- 防御削弱
			SpellName(159709),
			-- 受伤
			SpellName(155569),
			-- 烈焰
			SpellName(158241),
			-- 奥能动荡
			SpellName(163372),
			-- 奥术之伤
			SpellName(167200),

			-- 6   克拉戈
			-- 腐蚀能量
			SpellName(161242),
			-- 压制力场
			SpellName(161345),
			-- 魔能散射:冰霜
			SpellName(172813),
			-- 魔能散射:暗影
			SpellName(162184),
			-- 魔能散射:火焰
			SpellName(162185),
			-- 魔能散射:奥术
			SpellName(162186),
			-- 魔能散射:邪能
			SpellName(172895),
			SpellName(172917),
			-- 统御之力
			SpellName(163472),
			-- 废灵标记
			SpellName(172886),
			-- 废灵壁垒
			SpellName(163134),

			-- 7   元首马尔高克
			-- 混沌标记
			SpellName(158605),
			-- 混沌标记:偏移
			SpellName(164176),
			-- 混沌标记:强固
			SpellName(164178),
			-- 混沌标记:复制
			SpellName(164191),
			-- 拘禁
			SpellName(158619),
			-- 碾碎护甲
			SpellName(158553),
			-- 锁定
			SpellName(157763),
			-- 减速
			SpellName(157801),
			-- 毁灭共鸣
			SpellName(159200),
			SpellName(174106),
			-- 烙印
			SpellName(156225),
			-- 烙印:偏移
			SpellName(164004),
			-- 烙印:强固
			SpellName(164005),
			-- 烙印:复制
			SpellName(164006),
			-- 蔓延暗影(M)
			SpellName(176533),
			-- 深渊凝视(M)
			SpellName(176537),
			-- 深渊凝视(爆炸)(M)
			SpellName(165595),
			-- 无尽黑暗制(M)
			SpellName(165102),
			-- 熵能冲击(M)
			SpellName(165116),		
			
		-----------------------------------------------------------------
		-- PvP
		-----------------------------------------------------------------
			-- Death Knight
			SpellName(115001),	-- Remorseless Winter
			SpellName(108194),	-- Asphyxiate
			SpellName(47476),	-- Strangulate
			SpellName(47481),	-- Gnaw (Ghoul)
			SpellName(91797),	-- Monstrous Blow (Mutated Ghoul)
			-- Druid
			SpellName(33786),	-- Cyclone
			SpellName(2637),	-- Hibernate
			SpellName(339),		-- Entangling Roots
			SpellName(78675),	-- Solar Beam
			-- Hunter
			SpellName(3355),	-- Freezing Trap
			SpellName(117526),	-- Binding Shot
			SpellName(1513),	-- Scare Beast
			SpellName(19503),	-- Scatter Shot
			SpellName(34490),	-- Silence Shot
			SpellName(19386),	-- Wyvern Sting

			-- Mage
			SpellName(31661),	-- Dragon's Breath
			SpellName(82691),	-- Ring of Frost
			SpellName(61305),	-- Polymorph
			SpellName(102051),	-- Frostjaw
			SpellName(55021),	-- Improved Counterspell
			SpellName(122),		-- Frost Nova
			SpellName(111340),	-- Ice Ward
			-- Monk
			SpellName(115078),	-- Paralysis
			-- Paladin
			SpellName(20066),	-- Repentance
			SpellName(853),		-- Hammer of Justice
			SpellName(105593),	-- Fist of Justice
			SpellName(105421),	-- Blinding Light
			-- Priest
			SpellName(605),		-- Dominate Mind
			SpellName(8122),	-- Psychic Scream
			SpellName(113792),	-- Psychic Terror
			SpellName(64044),	-- Psychic Horror
			SpellName(15487),	-- Silence
			SpellName(6778),	-- Silence
			-- Rogue
			SpellName(2094),	-- Blind
			SpellName(1776),	-- Gouge
			SpellName(6770),	-- Sap
			-- Shaman
			SpellName(51514),	-- Hex
			SpellName(118905),	-- Static Charge
			SpellName(3600),	-- Earthbind
			SpellName(8056),	-- Frost Shock
			SpellName(63685),	-- Freeze
			-- Warlock
			SpellName(118699),	-- Fear
			SpellName(104045),	-- Sleep
			SpellName(6789),	-- Mortal Coil
			SpellName(5484),	-- Howl of Terror
			SpellName(6358),	-- Seduction (Succubus)
			SpellName(115268),	-- Mesmerize (Shivarra)
			SpellName(30283),	-- Shadowfury
			-- Warrior
			SpellName(46968),	-- Shockwave
			SpellName(20511),	-- Intimidating Shout
			--测试用
			--SpellName(41425),
		}

		ReverseTimer = {
		},
		
		ORD:RegisterDebuffs(debuffids)
	end