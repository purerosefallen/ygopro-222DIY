--雨天
function c80000148.initial_effect(c)
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
	e2:SetTarget(c80000148.adtg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)   
	--Atk/def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTarget(c80000148.adtg1)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(-400)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)   
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c80000148.discon)
	e4:SetOperation(c80000148.disop)
	c:RegisterEffect(e4)
	--decrease tribute
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DECREASE_TRIBUTE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e5:SetValue(0x1)
	c:RegisterEffect(e5)  
end
function c80000148.discon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local Attribute=a:GetAttribute()
	local at=Duel.GetAttackTarget()
	return at and Attribute==ATTRIBUTE_WATER 
end
function c80000148.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
function c80000148.filter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000148.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c80000148.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c80000148.damop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local d=Duel.GetMatchingGroupCount(c80000148.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*300
	Duel.Recover(tp,d,REASON_EFFECT)
end
function c80000148.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000148.adtg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000148.adtg1(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000148.filter(c)
	return c:IsFaceup() and c:IsCode(80000146)
end
function c80000148.handcon(e)
	return Duel.IsExistingMatchingCard(c80000148.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end