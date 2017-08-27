--冰雹
function c80000213.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c80000213.adtg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)  
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c80000213.damcon2)
	e4:SetOperation(c80000213.damop2)
	c:RegisterEffect(e4) 
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(c80000213.atkcon)
	e5:SetValue(c80000213.atlimit)
	c:RegisterEffect(e5)
	--Activate1
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80000213,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c80000213.condition)
	e6:SetTarget(c80000213.target)
	e6:SetOperation(c80000213.activate)
	c:RegisterEffect(e6)
	--Atk/def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTarget(c80000213.adtg1)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(-400)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)	   
end
function c80000213.adtg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000213.adtg1(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000213.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000213.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c80000213.cfilter,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80000213.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
		Duel.Hint(HINT_CARD,0,80000213)
		Duel.Damage(p,500,REASON_EFFECT)
end
function c80000213.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000213.atkcon(e)
	return Duel.IsExistingMatchingCard(c80000213.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c80000213.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function c80000213.atlimit(e,c)
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(c80000213.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,c,c:GetAttack())
end
function c80000213.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsControler(tp) and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_WATER)
end
function c80000213.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c80000213.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end