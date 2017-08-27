--黑飞球
function c13254036.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254036,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,13254036)
	e2:SetCost(c13254036.cost1)
	e2:SetTarget(c13254036.target)
	e2:SetOperation(c13254036.operation)
	c:RegisterEffect(e2)	
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254036,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,23254036)
	e3:SetCost(c13254036.cost2)
	e3:SetTarget(c13254036.eftg)
	e3:SetOperation(c13254036.efop)
	c:RegisterEffect(e3)
	--atkchange
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13254036,3))
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,33254036)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCost(c13254036.spcost)
	e4:SetCondition(c13254036.spcon)
	e4:SetTarget(c13254036.sptarget)
	e4:SetOperation(c13254036.spoperation)
	c:RegisterEffect(e4)
end
function c13254036.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,1000)
end
function c13254036.adfilter(c)
	return (c:GetAttack()>0 or c:IsAttackPos()) and not c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c13254036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254036.adfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c13254036.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13254036.adfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
		tc=g:GetNext()
	end
end
function c13254036.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c13254036.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(c13254036.cfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13254036.cfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13254036.effilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFaceup()
end
function c13254036.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c13254036.effilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254036.effilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c13254036.effilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c13254036.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(13254036,0))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetHintTiming(TIMING_DAMAGE_STEP)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,13254036)
		e1:SetCost(c13254036.cost1)
		e1:SetTarget(c13254036.target)
		e1:SetOperation(c13254036.operation)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(13254036,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		if not tc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
		end
end
function c13254036.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsCanTurnSet() and c:IsFaceup()
end
function c13254036.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c13254036.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c13254036.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254036.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c13254036.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13254036.filter,tp,LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()>0 then
		Duel.ShuffleSetCard(g1)
	end
end
