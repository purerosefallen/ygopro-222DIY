--3L·紧闭的恋之瞳
local m=37564826
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.Fusion_3L(c,Senya.check_fusion_set_3L,cm.mfilter,2,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(m)
	e2:SetValue(cm.custom_ctlm_3L)
	c:RegisterEffect(e2)
end
cm.custom_ctlm_3L=2
function cm.mfilter(g)
	return g:IsExists(Card.IsFusionType,1,nil,TYPE_FUSION)
end