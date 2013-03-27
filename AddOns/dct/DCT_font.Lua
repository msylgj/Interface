DCT_FONT_DEFAULT = {
		{name = "GameTooltipText",path = "Fonts\\ARKai_T.TTF",active = true,},
		{name = "TextStatusBarText",path = "Fonts\\ARKai_T.TTF",active = true},
		{name = "GameFontNormal",path = "Fonts\\ARKai_T.TTF",active = true},
		{name = "FontForIslersWoWUI",path = "Fonts\\ARKai_T.TTF",active = true},
		{name = "",path = "",active = false},
		{name = "",path = "",active = false},
		{name = "",path = "",active = false},
		{name = "",path = "",active = false},
		{name = "",path = "",active = false},
		{name = "",path = "",active = false},
		{name = "",path = "",active = false},
		{name = "",path = "",active = false},
}

DCT_FONT_DEFAULT[1].path = select(1,GameTooltipText:GetFont())
DCT_FONT_DEFAULT[2].path = select(1,TextStatusBarText:GetFont())
DCT_FONT_DEFAULT[3].path = select(1,GameFontNormal:GetFont())
