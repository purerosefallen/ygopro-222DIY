--术之从者 童谣
function c21401119.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xf05),1)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0xf0f)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c21401119.accon)
	e1:SetTarget(c21401119.actg)
	e1:SetOperation(c21401119.acop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21401119.tkcost)
	e2:SetTarget(c21401119.tktg)
	e2:SetOperation(c21401119.tkop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1)
	e3:SetCondition(c21401119.negcon)
	e3:SetCost(c21401119.negcost)
	e3:SetTarget(c21401119.negtg)
	e3:SetOperation(c21401119.negop)
	c:RegisterEffect(e3)
end
function c21401119.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c21401119.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0xf0f,2,false) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0xf0f)
end
function c21401119.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xf0f,2)
	end
end
function c21401119.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,4,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,4,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+4 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401119.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21401131,0,0x4011,300,300,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c21401119.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,21401131,0,0x4011,300,300,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	for i=1,ft do
		local token=Duel.CreateToken(tp,21401131)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c21401119.cfilter(c)
	return c:IsCode(21401131) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c21401119.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c21401119.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c21401119.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c21401119.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c21401119.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c21401119.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end