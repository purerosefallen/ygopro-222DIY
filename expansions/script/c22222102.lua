--绝对突破白泽球
function c22222102.initial_effect(c)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c22222102.condition2)
	e4:SetCost(c22222102.cost2)
	e4:SetTarget(c22222102.target2)
	e4:SetOperation(c22222102.activate2)
	c:RegisterEffect(e4)
end
c22222102.named_with_Shirasawa_Tama=1
function c22222102.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22222102.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c22222102.IsShirasawaTama(c)
end
function c22222102.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_NEGATE)
end
function c22222102.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22222102.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c22222102.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22222102.tgfilter(c,tpe)
	return c:IsType(tpe) and c22222102.IsShirasawaTama(c) and c:IsAbleToHand()
end
function c22222102.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tpe=eg:GetFirst():GetOriginalType()
	if chk==0 then return Duel.IsExistingMatchingCard(c22222102.tgfilter,tp,LOCATION_DECK,0,1,nil,tpe) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c22222102.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tpe=eg:GetFirst():GetOriginalType()
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(c22222102.tgfilter,tp,LOCATION_DECK,0,1,nil,tpe) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		local g=Duel.SelectMatchingCard(tp,c22222102.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tpe)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end