--囚鸟的信使
function c2116002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,2116000)
	e1:SetCondition(c2116002.spcon)
	e1:SetOperation(c2116002.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(POS_FACEUP,0)
	e2:SetCountLimit(1,2116001)
	e2:SetCondition(c2116002.spcon2)
	e2:SetOperation(c2116002.spop2)
	c:RegisterEffect(e2)
end
function c2116002.filter(c)
	return c:IsCode(2116000) and c:IsAbleToGraveAsCost()
end
function c2116002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c2116002.filter,tp,LOCATION_DECK,0,1,c)
end
function c2116002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c2116002.filter,tp,LOCATION_DECK,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c2116002.filter2(c)
	return c:IsCode(2116000) and c:IsAbleToRemoveAsCost()
end
function c2116002.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c2116002.filter2,tp,LOCATION_GRAVE,0,1,c)
end
function c2116002.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c2116002.filter2,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end