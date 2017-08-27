--蝶舞·反魂
function c1111005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
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
	return c1111005.IsDw(c) and c:IsAbleToHand()
end
function c1111005.filter2(c,e,tp)
	return c:GetLevel()<6 and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
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
	if chk==0 then return ((Duel.IsExistingMatchingCard(c1111005.costfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1111005.filter1,tp,LOCATION_DECK,0,1,nil)) or (Duel.IsExistingMatchingCard(c1111005.costfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1111005.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp))) end
	local g=Duel.SelectMatchingCard(tp,c1111005.cfilterx,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(Duel.GetOperatedGroup():GetFirst())
end
function c1111005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c1111005.op1(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	if dc and dc:IsCode(1110111) and Duel.IsExistingMatchingCard(c1111005.filter1,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1111005.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if dc and dc:IsCode(1110112) and Duel.IsExistingMatchingCard(c1111005.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1111005.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
