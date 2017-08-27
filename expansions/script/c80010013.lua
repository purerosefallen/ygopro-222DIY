--下架女神 美好世界
function c80010013.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,80010013)
	e1:SetCondition(c80010013.condition2)
	e1:SetCost(c80010013.negcost2)
	e1:SetTarget(c80010013.target)
	e1:SetOperation(c80010013.activate)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,80010013)
	e3:SetCondition(c80010013.condition)
	e3:SetCost(c80010013.reccost)
	e3:SetTarget(c80010013.target)
	e3:SetOperation(c80010013.activate)
	c:RegisterEffect(e3)
end
function c80010013.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80010013.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80010013.negcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c80010013.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c80010013.condition1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_GRAVE) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c80010013.condition2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_REMOVED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c80010013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c80010013.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end