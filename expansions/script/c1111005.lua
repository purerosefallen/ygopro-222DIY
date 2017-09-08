--蝶舞·反魂
function c1111005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1111005.cost1)
	e1:SetTarget(c1111005.tg1)
	e1:SetOperation(c1111005.op1)
	c:RegisterEffect(e1)
end
--
c1111005.named_with_Dw=1
function c1111005.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111005.filter1(c)
	return c:IsAbleToDeck()
end
function c1111005.filter2(c)
	return c:GetLevel()<6 and c:IsFaceup() and c:IsAbleToHand() and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
end
function c1111005.costfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(1110111)
end
function c1111005.costfilter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(1110112)
end
function c1111005.cfilterx(c)
	return (c:IsCode(1110112) or c:IsCode(1110111)) and c:IsAbleToRemoveAsCost()
end
function c1111005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((Duel.IsExistingMatchingCard(c1111005.costfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1111005.filter1,tp,LOCATION_GRAVE,0,1,nil)) or (Duel.IsExistingMatchingCard(c1111005.costfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1111005.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil))) end
	local g=Duel.SelectMatchingCard(tp,c1111005.cfilterx,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(Duel.GetOperatedGroup():GetFirst())
end
function c1111005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dc=e:GetLabelObject()
	if dc then
		if dc:IsCode(1110111) then
			Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
		else 
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
		end
	end
end
function c1111005.op1(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	if dc and dc:IsCode(1110111) and Duel.IsExistingMatchingCard(c1111005.filter1,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c1111005.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
	if dc and dc:IsCode(1110112) and Duel.IsExistingMatchingCard(c1111005.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=Duel.SelectMatchingCard(tp,c1111005.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
