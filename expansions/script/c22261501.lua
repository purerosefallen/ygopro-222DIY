--掌心孵化
function c22261501.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22261501.target)
	e1:SetOperation(c22261501.activate)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c22261501.cost)
	e1:SetOperation(c22261501.op)
	c:RegisterEffect(e1)
end
function c22261501.filter(c)
	return c:IsCode(22260005) and c:IsAbleToHand()
end
function c22261501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22261501.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22261501.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c22261501.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(22261501,0)) then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_EFFECT,nil)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c22261501.cfilter(c)
	local a=Duel.IsExistingMatchingCard(c22261501.filter1,tp,LOCATION_DECK,0,1,nil)
	local b=Duel.IsExistingMatchingCard(c22261501.filter2,tp,LOCATION_DECK,0,1,nil)
	if a and b then
		return c:IsCode(22261001,22261101) and c:IsAbleToDeckAsCost() and ((c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
	elseif a and not b then
		return c:IsCode(22261001) and c:IsAbleToDeckAsCost() and ((c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
	elseif b and not a then
		return c:IsCode(22261101) and c:IsAbleToDeckAsCost() and ((c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
	end
end
function c22261501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22261501.cfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c22261501.cfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.SendtoDeck(tc,nil,1,REASON_COST)
end
function c22261501.filter1(c)
	return c:IsCode(22261101) and c:IsAbleToHand()
end
function c22261501.filter2(c)
	return c:IsCode(22261001) and c:IsAbleToHand()
end
function c22261501.op(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==22261001 then
		local tc=Duel.GetFirstMatchingCard(c22261501.filter1,tp,LOCATION_DECK,0,nil)
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	elseif e:GetLabel()==22261101 then
		local tc=Duel.GetFirstMatchingCard(c22261501.filter2,tp,LOCATION_DECK,0,nil)
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end