--蓝玫瑰之灵女 无伤
function c80004010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80004010.ffilter,4,2)
	c:EnableReviveLimit() 
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c80004010.tgvalue)
	c:RegisterEffect(e2)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCondition(c80004010.negcon)
	e5:SetCost(c80004010.negcost)
	e5:SetTarget(c80004010.negtg)
	e5:SetOperation(c80004010.negop)
	c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCost(c80004010.cost)
	e6:SetCondition(c80004010.rkcon)
	e6:SetTarget(c80004010.rmtg1)
	e6:SetOperation(c80004010.rmop1)
	c:RegisterEffect(e6)
	--Attribute Dark
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_ADD_ATTRIBUTE)
	e7:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e7:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e7)
	--Attribute Dark
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_ADD_RACE)
	e8:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e8:SetValue(RACE_PLANT)
	c:RegisterEffect(e8)
end
function c80004010.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
function c80004010.tgvalue(e,re,rp)
	return rp==e:GetHandlerPlayer()
end
function c80004010.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_CONTINUOUS+TYPE_DUAL+TYPE_FLIP+TYPE_PENDULUM+TYPE_TOON+TYPE_UNION+TYPE_SPIRIT) and Duel.IsChainNegatable(ev)
end
function c80004010.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80004010.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c80004010.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c80004010.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c80004010.rmop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c80004010.rkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c80004010.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER) and c:GetLevel()==4 and c:IsAbleToRemoveAsCost()
end
function c80004010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80004010.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80004010.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end