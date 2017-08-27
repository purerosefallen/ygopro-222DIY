--1998 - 十六夜 黑化的木头 -
function c80006039.initial_effect(c)
	c:EnableReviveLimit()   
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdocon)
	e1:SetTarget(c80006039.damtg)
	e1:SetOperation(c80006039.damop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(c80006039.disop1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c80006039.atkcon)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c80006039.disop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e5) 
	--end battle phase
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80006039,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1,80006039+EFFECT_COUNT_CODE_DUEL)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(c80006039.condition)
	e6:SetCost(c80006039.cost)
	e6:SetOperation(c80006039.operation)
	c:RegisterEffect(e6)
	--end battle phase
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80006039,2))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCountLimit(1,80006039+EFFECT_COUNT_CODE_DUEL)
	e7:SetCondition(c80006039.condition)
	e7:SetCost(c80006039.thcost)
	e7:SetOperation(c80006039.operation)
	c:RegisterEffect(e7)
	--actlimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,1)
	e8:SetValue(c80006039.aclimit)
	e8:SetCondition(c80006039.actcon)
	c:RegisterEffect(e8)
	--control
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e9)
end
function c80006039.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80006039.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c80006039.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80006039.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c80006039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80006039.operation(e,tp,eg,ep,ev,re,r,rp)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
function c80006039.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsRace(RACE_SPELLCASTER)
end
function c80006039.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsRace(RACE_SPELLCASTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e2)
	end
end
function c80006039.disop1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and (loc==LOCATION_MZONE or loc==LOCATION_GRAVE or loc==LOCATION_HAND or loc==LOCATION_REMOVED)
		and re:GetHandler():IsRace(RACE_SPELLCASTER) then
		Duel.NegateEffect(ev)
	end
end
function c80006039.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c80006039.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end