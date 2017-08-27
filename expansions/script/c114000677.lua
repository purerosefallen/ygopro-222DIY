--魔力を高めるＧｉｆｔ（ギフト）
function c114000677.initial_effect(c)
	--unique self
	c:SetUniqueOnField(1,0,114000677)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c114000677.cost)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetLabel(0)
	e2:SetCondition(c114000677.condition)
	e2:SetValue(800)
	c:RegisterEffect(e2)
end
function c114000677.cfilter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c114000677.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000677.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c114000677.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c114000677.cfilter(c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsType(TYPE_MONSTER)
end
function c114000677.condition(e,c)
	if c==nil then return true end
	return not Duel.IsExistingMatchingCard(c114000677.cfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end