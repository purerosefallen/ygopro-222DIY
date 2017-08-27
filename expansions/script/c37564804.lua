--3L·困惑之月
local m=37564804
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.fusion_att_3L=ATTRIBUTE_WIND
function cm.initial_effect(c)
	Senya.Fusion_3L_Attribute(c,cm)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and Duel.IsExistingMatchingCard(cm.f,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,m)==0
	end)
	e0:SetOperation(cm.tdop)
	c:RegisterEffect(e0)
end
function cm.f(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.f,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end