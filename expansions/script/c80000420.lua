--ＰＭ 快龙
function c80000420.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,c80000420.tfilter,aux.FilterBoolFunction(Card.IsCode,80000053))
	c:EnableReviveLimit() 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)	
	--halve damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80000420.condition)
	e2:SetValue(c80000420.val)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c80000420.efilter)
	c:RegisterEffect(e3) 
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000420,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCost(c80000420.spcost)
	e4:SetCondition(c80000420.spcon)
	e4:SetOperation(c80000420.spop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000420,6))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c80000420.cost)
	e5:SetTarget(c80000420.target)
	e5:SetOperation(c80000420.operation)
	c:RegisterEffect(e5)
end
function c80000420.tfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsSetCard(0x2d0)
end
function c80000420.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000420.condition(e)
	return Duel.GetLP(tp)>=8000
end
function c80000420.val(e,re,dam,r,rp,rc)
	return math.ceil(dam/2)
end
function c80000420.costfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function c80000420.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000420.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c80000420.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80000420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80000420.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000420.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsType(TYPE_MONSTER) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c80000420.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80000420,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	else if tc:IsType(TYPE_SPELL) then
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80000420,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCountLimit(1,80000420)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.ShuffleHand(tp)
end
end
function c80000420.costfilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c80000420.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000420.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c80000420.costfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function c80000420.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c80000420.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	else
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	end
	e1:SetCountLimit(1)
	e1:SetCondition(c80000420.spcon2)
	e1:SetOperation(c80000420.spop2)
	c:RegisterEffect(e1)
	c:SetTurnCounter(0)
end
function c80000420.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c80000420.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end