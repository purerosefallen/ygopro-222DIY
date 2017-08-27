--现实否定！
function c80006042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,80006042)
	e1:SetCondition(c80006042.condition)
	e1:SetTarget(c80006042.target)
	e1:SetOperation(c80006042.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80006042.handcon)
	c:RegisterEffect(e2)
end
function c80006042.filter(c)
	return c:IsFaceup() and (c:IsCode(80006003) or c:IsCode(80006006))
end
function c80006042.handcon(e)
	return Duel.IsExistingMatchingCard(c80006042.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80006042.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2de)
end
function c80006042.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80006042.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and 
		not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c80006042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80006042.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end