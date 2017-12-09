--Psychether Knight, Lancella
function c17029605.initial_effect(c)
	--ATK + DEF change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17029605,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17029605+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17029605.atktg)
	e1:SetOperation(c17029605.atkop)
	c:RegisterEffect(e1)
	--Activate, SS self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17029605,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,17029605+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c17029605.spcost)
	e2:SetTarget(c17029605.sptg)
	e2:SetOperation(c17029605.spop)
	c:RegisterEffect(e2)
	--reveal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17029605,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c17029605.revcon)
	e3:SetTarget(c17029605.revtg)
	e3:SetOperation(c17029605.revop)
	c:RegisterEffect(e3)
end
function c17029605.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c17029605.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17029605.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c17029605.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c17029605.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetBaseAttack()+500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetBaseDefense()+500)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c17029605.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and c:IsAbleToRemoveAsCost()
end
function c17029605.cfcost(c)
	return c:IsCode(17029609) and c:IsAbleToRemoveAsCost()
end
function c17029605.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c17029605.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c17029605.cfcost,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(17029609,1))) then
		local tg=Duel.GetFirstMatchingCard(c17029605.cfcost,tp,LOCATION_GRAVE,0,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c17029605.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c17029605.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17029605,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17029605.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,17029605,0x720,0x21,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		c:AddMonsterAttributeComplete()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(17029602,4))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCountLimit(1)
		e2:SetValue(c17029605.valct)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x47e0000)
		e4:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(17029605,3))
		e5:SetCategory(CATEGORY_ATKCHANGE)
		e5:SetHintTiming(TIMING_DAMAGE_STEP)
		e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetCountLimit(1)
		e5:SetCondition(c17029605.atkcon1)
		e5:SetTarget(c17029605.atktg1)
		e5:SetOperation(c17029605.atkop1)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5,true)
		Duel.SpecialSummonComplete()
	end
end
function c17029605.valct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c17029605.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsSetCard(0x720) and a:IsRelateToBattle())
		or (d:GetControler()==tp and d:IsSetCard(0x720) and d:IsRelateToBattle()))
end
function c17029605.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c17029605.atkop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c17029605.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c17029605.announce_filter))
	Duel.SetTargetParam(ac)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetOwnerPlayer(tp)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		if a:GetControler()==tp then
			e1:SetValue(d:GetAttack()/2)
			a:RegisterEffect(e1)
		else
			e1:SetValue(a:GetAttack()/2)
			d:RegisterEffect(e1)
		end
	end
end
function c17029605.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x720) and not c:IsCode(17029605)
end
function c17029605.revcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17029605.cfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler())
end
function c17029605.revfilter(c)
	return not c:IsPublic()
end
function c17029605.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17029605.revfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c17029605.revop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c17029605.revfilter,tp,0,LOCATION_HAND,1,1,nil)
    Duel.HintSelection(g)
    local tc=g:GetFirst()
    if tc then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
