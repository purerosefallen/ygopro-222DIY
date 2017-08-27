--3L·Sweets Magic
local m=37564803
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.fusion_att_3L=ATTRIBUTE_FIRE
function cm.initial_effect(c)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_FUSION)
	Senya.Fusion_3L_Attribute(c,cm)
end
