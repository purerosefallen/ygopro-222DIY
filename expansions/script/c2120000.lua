--铁血人形-代理人
function c2120000.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2120000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,2120000)
	e1:SetCost(c2120000.cost)
	e1:SetCondition(c2120000.discon)
	e1:SetTarget(c2120000.target)
	e1:SetOperation(c2120000.operation)
	c:RegisterEffect(e1)
	--attup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2120000,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,2121000)
	e2:SetCondition(c2120000.discon)
	e2:SetCost(c2120000.cost2)
	e2:SetOperation(c2120000.operation2)
	c:RegisterEffect(e2)
end
function c2120000.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5219) and c:IsType(TYPE_MONSTER)
end
function c2120000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c2120000.costfilter,1,nil) and  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local g=Duel.SelectReleaseGroup(tp,c2120000.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c2120000.filter(c,e,tp)
	return c:IsSetCard(0x5219) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2120000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingMatchingCard(c2120000.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c2120000.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2120000.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c2120000.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5219) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c2120000.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c2120000.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2120000.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c2120000.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c2120000.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end