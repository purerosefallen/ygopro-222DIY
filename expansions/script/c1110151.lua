--灵都·司掌命运的使者
function c1110151.initial_effect(c)
	c:SetUniqueOnField(1,0,1110151)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,sp,st)
		return se:IsHasType(EFFECT_TYPE_ACTIONS) and c1110151.filterx(se:GetHandler())
	end)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c1110151.con3)
	e3:SetCost(c1110151.cost3)
	e3:SetTarget(c1110151.tg3)
	e3:SetOperation(c1110151.op3)
	c:RegisterEffect(e3)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c1110151.filter6)
	c:RegisterEffect(e6)
--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_ATTACK_COST)
	e7:SetCost(c1110151.cost7)
	e7:SetOperation(c1110151.op7)
	c:RegisterEffect(e7)
--
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(1110151,0))
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e8:SetCode(EVENT_CHAINING)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetCountLimit(2,1110151)
	e8:SetCondition(c1110151.con8)
	e8:SetCost(c1110151.cost8)
	e8:SetTarget(c1110151.tg8)
	e8:SetOperation(c1110151.op8)
	c:RegisterEffect(e8)
--
end
--
c1110151.named_with_Ld=1
function c1110151.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110151.filterx(c)
	return c:IsCode(1111301)
end
--
function c1110151.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c1110151.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
end
--
function c1110151.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_ONFIELD)
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1110151.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,8000)
	Duel.SetLP(1-tp,8000)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		local e3_1=Effect.CreateEffect(e:GetHandler())
		e3_1:SetType(EFFECT_TYPE_FIELD)
		e3_1:SetCode(EFFECT_CHANGE_DAMAGE)
		e3_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_1:SetTargetRange(0,1)
		e3_1:SetValue(0)
		e3_1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3_1,tp)
		local e3_2=e3_1:Clone()
		e3_2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e3_2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3_2,tp)
	end
end
--
function c1110151.filter6(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
--
function c1110151.filter7(c,e)
	return c:IsAbleToGraveAsCost()
end
function c1110151.cost7(e,c,tp)
	return Duel.IsExistingMatchingCard(c1110151.filter7,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
--
function c1110151.op7(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1110151.filter7,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
--
function c1110151.con8(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler() and Duel.IsChainNegatable(ev)
end
--
function c1110151.filter8(c)
	return c1110151.IsLd(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c1110151.cost8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110151.filter8,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c1110151.filter8,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
--
function c1110151.tg8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
--
function c1110151.op8(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
--