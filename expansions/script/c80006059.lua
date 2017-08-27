--沉睡的终结
function c80006059.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80006059,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80006059+EFFECT_COUNT_CODE_DUEL)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c80006059.condition)
	e1:SetTarget(c80006059.destg)
	e1:SetOperation(c80006059.desop)
	c:RegisterEffect(e1)  
end
function c80006059.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2de)
end
function c80006059.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80006059.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c80006059.filter(c)
	return c:IsAbleToDeck()
end
function c80006059.tgfilter(c)
	return (c:IsCode(80006009) or c:IsCode(80006033) or c:IsCode(80006036) or c:IsCode(80006039) or c:IsCode(80006048)) and c:IsAbleToGrave()
end
function c80006059.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80006059.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c80006059.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80006059.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c80006059.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c80006059.tgfilter,p,LOCATION_DECK,0,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
			local sg=g:Select(p,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end