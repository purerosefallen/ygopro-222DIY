--3L·光之舞
local m=37564805
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.fusion_att_3L=ATTRIBUTE_LIGHT
function cm.initial_effect(c)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_FUSION)
	Senya.Fusion_3L_Attribute(c,cm)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.IsExistingMatchingCard(cm.f,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,m)==0
	end)
	e0:SetOperation(cm.tdop)
	c:RegisterEffect(e0)
end
function cm.f(c)
	return c:IsAbleToHand()
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.f,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
