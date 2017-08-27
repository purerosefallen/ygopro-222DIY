--3L·樱华月想
local m=37564802
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.fusion_att_3L=ATTRIBUTE_DARK
function cm.initial_effect(c)
	Senya.Fusion_3L_Attribute(c,cm)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,m)==0
	end)
	e0:SetOperation(cm.skipop)
	c:RegisterEffect(e0)
end
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.Draw(tp,1,REASON_EFFECT)
end