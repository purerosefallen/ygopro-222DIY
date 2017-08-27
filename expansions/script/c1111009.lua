--于拂晓徘徊之风
function c1111009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,1111009+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1111009.cost1)
	e1:SetTarget(c1111009.tg1)
	e1:SetOperation(c1111009.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1111009.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1111009.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g2<=g and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Draw(tp,1,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
--
function c1111009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--
function c1111009.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAbleToDeck() then
		e:GetHandler():CancelToGrave()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
	local tc=e:GetLabelObject()
	if tc and tc~=nil and ((c1111009.IsLd(tc) and tc:IsType(TYPE_MONSTER)) or tc:IsType(TYPE_SPELL)) then
		Duel.ConfirmCards(1-tp,tc)
		if Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(1111009,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
		end
	else
		Duel.ConfirmCards(1-tp,tc)
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end


