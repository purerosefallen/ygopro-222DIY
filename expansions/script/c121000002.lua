--樱之大地
function c121000002.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c121000002.target)
	e1:SetOperation(c121000002.activate)
	c:RegisterEffect(e1)
end
function c121000002.filter(c)
	return c:IsSetCard(0x121) and c:IsAbleToHand()
end
function c121000002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c121000002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c121000002.tdfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c121000002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c121000002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		if Duel.IsExistingMatchingCard(c121000002.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(23310009,5)) then
		local tg=Duel.SelectMatchingCard(tp,c121000002.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	     if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	end
end
end
end