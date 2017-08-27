--口袋妖怪 哈克龙
function c80000053.initial_effect(c)
c:SetUniqueOnField(1,1,80000053)
	--synchro summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),aux.FilterBoolFunction(Card.IsCode,80000052))
	c:EnableReviveLimit() 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1) 
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetTarget(c80000053.distg1)
	c:RegisterEffect(e4) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000053,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80000053.discon)
	e2:SetCost(c80000053.discost)
	e2:SetTarget(c80000053.distg)
	e2:SetOperation(c80000053.disop)
	c:RegisterEffect(e2) 
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000053,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80000053.cost)
	e3:SetTarget(c80000053.target)
	e3:SetOperation(c80000053.operation)
	c:RegisterEffect(e3)
end
function c80000053.distg1(e,c)
	return c:IsType(TYPE_FIELD)
end
function c80000053.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
function c80000053.cfilter(c)
	return c:IsSetCard(0x2d0) and c:IsAbleToRemoveAsCost()
end
function c80000053.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000053.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80000053.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80000053.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80000053.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c80000053.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c80000053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000053.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c80000053.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80000053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80000053.operation(e,tp,eg,ep,ev,re,r,rp)
		local ct=Duel.Draw(tp,1,REASON_EFFECT)
		if ct==0 then return end
		local dc=Duel.GetOperatedGroup():GetFirst()
		if dc:IsSetCard(0x2d0) and Duel.IsPlayerCanDraw(tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(80000053,0)) then
			Duel.ConfirmCards(1-tp,dc)
			Duel.Recover(tp,1000,REASON_EFFECT)
			Duel.Damage(1-tp,1000,REASON_EFFECT)
			Duel.ShuffleHand(tp)
end
end