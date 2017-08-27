--★魔法少女林黙娘
function c114000785.initial_effect(c)
	c:SetUniqueOnField(1,1,114000785)
	--summon or set without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114000785,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c114000785.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
end
function c114000785.filter(c)
	return c:IsSetCard(0xcabb)
	and c:IsType(TYPE_MONSTER)
end
function c114000785.ntcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114000785.filter,tp,LOCATION_GRAVE,0,1,nil)
end