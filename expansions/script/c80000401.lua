--ＰＭ 长耳兔
function c80000401.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c80000401.synfilter,aux.NonTuner(c80000401.synfilter),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--multi atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000401,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,80000401)
	e2:SetCondition(c80000401.mtcon)
	e2:SetCost(c80000401.mtcost)
	e2:SetTarget(c80000401.mttg)
	e2:SetOperation(c80000401.mtop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000401,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,80000402)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetOperation(c80000401.activate)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
end
function c80000401.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_UPDATE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,LOCATION_MZONE)
	Duel.RegisterEffect(e1,tp)
end
function c80000401.synfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c80000401.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=1 and Duel.GetCurrentPhase()==PHASE_MAIN1
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_BP)
end
function c80000401.cfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost()
end
function c80000401.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000401.cfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c80000401.cfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80000401.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c80000401.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c80000401.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000401.atktg(e,c)
	return not c:IsAttribute(ATTRIBUTE_EARTH)
end