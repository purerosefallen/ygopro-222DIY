--quesar
local m=37564032
local cm=_G["c"..m]

xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,6,4,cm.ovfilter,aux.Stringid(m,0),63)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.atkcon)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==37564022 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler())
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if not Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler()) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,e:GetHandler())
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		local tc=sg:GetFirst()
		Senya.CopyStatusAndEffect(e,nil,tc,true,2)
end