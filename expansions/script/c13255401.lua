--球球世界
function c13255401.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c13255401.val)
	c:RegisterEffect(e2)
	--reduce battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c13255401.rdcon)
	e3:SetOperation(c13255401.rdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c13255401.iecon)
	e4:SetValue(c13255401.efilter)
	c:RegisterEffect(e4)
end
function c13255401.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsType(TYPE_MONSTER) and not re:GetHandler():IsAttackBelow(300) then
		return 300
	else return dam end
end
function c13255401.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=eg:GetFirst()
	return ep~=ac:GetControler() and not ac:IsAttackBelow(300) and not ac:IsImmuneToEffect(e)
end
function c13255401.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,300)
end
function c13255401.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c13255401.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(300) and c:IsDefenseBelow(200)
end
function c13255401.iecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c13255401.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
