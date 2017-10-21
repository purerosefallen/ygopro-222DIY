--清者自清
function c13255402.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13255402,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c13255402.condition)
	e1:SetTarget(c13255402.target)
	e1:SetOperation(c13255402.activate)
	c:RegisterEffect(e1)
	
end
function c13255402.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and re:GetActivateLocation()~=re:GetHandler():GetLocation() and (re:GetHandler():IsLocation(LOCATION_DECK) or re:GetHandler():IsAbleToDeck())
end
function c13255402.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not re:GetHandler():IsLocation(LOCATION_DECK) and re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c13255402.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not re:GetHandler():IsLocation(LOCATION_DECK) then
		if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)==0 then return end
	end
	Duel.ShuffleDeck(1-tp)
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(1-tp,1)
	local rg=Group.CreateGroup()
	if tc:IsLocation(LOCATION_DECK) then
		local tpe=tc:GetType()
		if bit.band(tpe,TYPE_TOKEN)==0 then
			local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil,tc:GetCode())
			rg:Merge(g1)
		end
	end
	if rg:GetCount()>0 then
		Duel.BreakEffect()
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 then
			if rg:FilterCount(Card.GetControler,nil,tp)==0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			if rg:FilterCount(Card.GetControler,nil,1-tp)>=3 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
