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