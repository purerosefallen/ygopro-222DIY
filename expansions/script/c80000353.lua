--月夜
function c80000353.initial_effect(c)
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
	e2:SetTarget(c80000353.aere)
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
	e7:SetTarget(c80000353.dfwe123)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(-400)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8) 
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c80000353.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)   
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCondition(c80000353.condition)
	e5:SetTarget(c80000353.atktarget)
	c:RegisterEffect(e5) 
end
function c80000353.aere(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c80000353.dfwe123(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c80000353.tgtg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c80000353.atktarget(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c80000353.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)==nil
end