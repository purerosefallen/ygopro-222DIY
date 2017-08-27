--未完成の楽園
function c114000169.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c114000169.condition)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--defup
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c114000169.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x221)
end
function c114000169.condition(e,c)
	return Duel.GetMatchingGroup(c114000169.filter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)>=2
end