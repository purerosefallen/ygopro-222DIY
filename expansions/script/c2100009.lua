--银星的祝福
function c2100009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,2100009)
	e2:SetTarget(c2100009.tdtg)
	e2:SetOperation(c2100009.tdop)
	c:RegisterEffect(e2)
end
function c2100009.tdfilter(c)
	return c:IsSetCard(0x3219) and c:IsAbleToDeck()
end
function c2100009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c2100009.tdfilter(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(c2100009.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c2100009.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c2100009.filter(c)
	return c:IsSetCard(0x3219) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2100009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c2100009.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end