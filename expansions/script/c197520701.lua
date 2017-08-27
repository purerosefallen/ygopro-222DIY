--长孙公主
function c197520701.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,197520701)
	e1:SetCost(c197520701.cost)
	e1:SetCondition(c197520701.condition)
	e1:SetTarget(c197520701.target)
	e1:SetOperation(c197520701.activate)
	c:RegisterEffect(e1)
end
function c197520701.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c197520701.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c197520701.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c197520701.activate(e,tp,eg,ep,ev,re,r,rp)
   Duel.NegateActivation(ev)
end
