--番长狮子/爆裂形态
function c80023020.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),99,99,c80023020.ovfilter,aux.Stringid(80023020,99),5)
	c:EnableReviveLimit()  
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)  
	--Double ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80023020,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c80023020.atkcon)
	e1:SetOperation(c80023020.atkop)
	c:RegisterEffect(e1)   
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80023020,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c80023020.immcost)
	e2:SetTarget(c80023020.tdtg)
	e2:SetOperation(c80023020.immop)
	c:RegisterEffect(e2) 
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80023020,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c80023020.atcon)
	e3:SetOperation(c80023020.atop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c80023020.aclimit)
	e4:SetCondition(c80023020.actcon)
	c:RegisterEffect(e4)
end
function c80023020.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c80023020.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable()
end
function c80023020.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c80023020.actfilter(c,tp)
	return c and c:IsFaceup() and c:IsSetCard(0xa2d6) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c80023020.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80023020.actcon(e)
	local tp=e:GetHandlerPlayer()
	return c80023020.actfilter(Duel.GetAttacker(),tp) or c80023020.actfilter(Duel.GetAttackTarget(),tp)
end
function c80023020.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80023020.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80023000) and Duel.GetLP(tp)<=2000
end
function c80023020.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c80023020.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c80023020.efilter(e,re)
	return re:GetOwner()~=e:GetOwner()
end
function c80023020.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c80023020.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end