--传说中的飞舞 
function c80000383.initial_effect(c)
	--change battle target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000383,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c80000383.cbcon)
	e1:SetOperation(c80000383.cbop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80000383.handcon)
	c:RegisterEffect(e2)
end
function c80000383.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x12d0)
end
function c80000383.handcon(e)
	return Duel.IsExistingMatchingCard(c80000383.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80000383.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttackTarget()
	return bt and bt:IsSetCard(0x2d0) and bt:IsControler(tp)
end
function c80000383.cbop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local bt=Duel.GetAttackTarget()
	if not (bt:IsRelateToBattle() and bt:IsControler(tp)) then return end
	if at:IsAttackable() and not at:IsStatus(STATUS_ATTACK_CANCELED) and Duel.Damage(tp,at:GetAttack(),REASON_EFFECT)>0 then
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
end
end