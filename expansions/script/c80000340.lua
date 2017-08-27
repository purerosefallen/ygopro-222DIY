--口袋妖怪 大甲
function c80000340.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80000340.ffilter,6,2)
	c:EnableReviveLimit() 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000340,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c80000340.cost)
	e2:SetTarget(c80000340.atktg)
	e2:SetOperation(c80000340.atkop)
	c:RegisterEffect(e2)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c80000340.atkop1)
	c:RegisterEffect(e4)
	--Double attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(c80000340.spcon)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
end
function c80000340.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000340.ffilter(c)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_INSECT)
end
function c80000340.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c80000340.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e:GetHandler():RegisterEffect(e1)
end
function c80000340.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000340.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
function c80000340.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local a=Duel.GetAttacker()
		local at=Duel.GetAttackTarget()
		return ((a==c and at and at:IsFaceup() and at:GetAttack()>0) or (at==c and a:GetAttack()>0))
			and not e:GetHandler():IsStatus(STATUS_CHAINING)
	end
	Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
end
function c80000340.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end