--★勝利のポケモン　ビクティニ
function c114000400.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c114000400.condition)
	e1:SetCost(c114000400.cost)
	e1:SetOperation(c114000400.operation)
	c:RegisterEffect(e1)
end
function c114000400.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (d~=nil and a:GetControler()==tp and ( a:IsSetCard(0x221) or a:IsSetCard(0x564) ) and a:IsRelateToBattle())
		or (d~=nil and d:GetControler()==tp and d:IsFaceup() and ( d:IsSetCard(0x221) or d:IsSetCard(0x564) ) and d:IsRelateToBattle())
end
function c114000400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,114000400)==0 and not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
	Duel.RegisterFlagEffect(tp,114000400,RESET_PHASE+PHASE_END,0,1)
end
function c114000400.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	--only plus 500 during damage calculation
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_CALCULATING)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetOperation(c114000400.atkop)
	a:RegisterEffect(e1)
	--no battle damage
	--local e2=Effect.CreateEffect(e:GetHandler())
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	--e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	--a:RegisterEffect(e2)
end
--up 500 sub
function c114000400.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(500)
	c:RegisterEffect(e1)
end