--怨恨·八重凛
function c14140003.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c14140003.discon)
	e1:SetOperation(c14140003.disop)
	c:RegisterEffect(e1)
end
function c14140003.cfilter(c,rc)
	return c:IsAbleToGraveAsCost()
end
function c14140003.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c14140003.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function c14140003.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,14140003*16) then return end
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.DiscardHand(tp,c14140003.cfilter,1,1,REASON_COST,e:GetHandler())
	Duel.NegateEffect(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end