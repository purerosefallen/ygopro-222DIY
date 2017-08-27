--★聖槍十三騎士団黒円卓VIII　魔女の鉄槌
function c114100429.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x11c0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,114100429)
	e1:SetTarget(c114100429.target)
	e1:SetOperation(c114100429.operation)
	c:RegisterEffect(e1)
	--on battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,114100429)
	e2:SetCondition(c114100429.bcon)
	e2:SetCost(c114100429.bcost)
	e2:SetTarget(c114100429.btg)
	e2:SetOperation(c114100429.bop)
	c:RegisterEffect(e2)
end
function c114100429.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(5)
end
function c114100429.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c114100429.filter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c114100429.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c114100429.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end


function c114100429.bcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetCurrentPhase()==PHASE_BATTLE then return false end
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at or not a then return false end
	if at:IsControler(tp) and a:IsControler(tp) then return false end
	if a:GetControler()==tp then
		return a and at and ( a:IsSetCard(0x221) or a:IsSetCard(0x988) )
	else
		return a and at and at:IsFaceup() and ( at:IsSetCard(0x221) or at:IsSetCard(0x988) )
	end
end
function c114100429.bcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c114100429.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c114100429.bop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if at:IsControler(tp) and a:IsControler(tp) then return end
	if at:IsControler(tp) then a,at=at,a end
	if at:IsFacedown() or not at:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-300)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	at:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	at:RegisterEffect(e2)
end
