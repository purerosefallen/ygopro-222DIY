--玻璃之空
local m=98600006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(0x14000)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(0x14000)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)>0 then
		c:SetTurnCounter(0)
		--SpecialSummon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCondition(cm.tcon)
		e1:SetOperation(cm.top)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		c:RegisterEffect(e1)
	end
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,re,r,rp,tp,0) end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_CHAINING)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(cm.discon)
		e3:SetCost(cm.cost)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetTarget(cm.distg)
		e3:SetOperation(cm.disop)
		c:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
		Duel.Hint(11,0,aux.Stringid(m,3))
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end


