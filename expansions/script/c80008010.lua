--冰霜城的剑令
function c80008010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c80008010.condition)
	e1:SetTarget(c80008010.target)
	e1:SetOperation(c80008010.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80008010.handcon)
	c:RegisterEffect(e2)
end
function c80008010.filter(c)
	return c:IsFaceup() and c:IsCode(80008002)
end
function c80008010.handcon(e)
	return Duel.IsExistingMatchingCard(c80008010.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c80008010.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c80008010.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80008010.cfilter,1,nil,1-tp)
end
function c80008010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c80008010.cfilter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c80008010.cfilter1(c)
	return c:IsFacedown() or not (c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WATER))
end
function c80008010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0 and not Duel.IsExistingMatchingCard(c80008010.cfilter1,tp,LOCATION_MZONE,0,1,nil) then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end
