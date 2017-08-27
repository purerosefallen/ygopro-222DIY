--最初的精灵
function c80000499.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80000499+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c80000499.target)
	e1:SetOperation(c80000499.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000499,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c80000499.thcost)
	e2:SetTarget(c80000499.thtg)
	e2:SetOperation(c80000499.thop)
	c:RegisterEffect(e2)
end
function c80000499.filter1(c,e,tp,b1,setcode)
	return c:GetLevel()==3 and c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c80000499.filter2(c,e,tp,b1,setcode)
	return c:GetLevel()==3 and c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000499.filter3(c,e,tp,b1,setcode)
	return c:GetLevel()==3 and c:IsSetCard(0x2d0) and c:IsRace(RACE_PLANT)
end
function c80000499.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
			Duel.IsExistingMatchingCard(c80000499.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c80000499.filter2,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c80000499.filter3,tp,LOCATION_DECK,0,1,nil) end
end
function c80000499.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c80000499.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c80000499.filter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c80000499.filter3,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=Duel.SelectMatchingCard(tp,c80000499.filter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectMatchingCard(tp,c80000499.filter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g3=Duel.SelectMatchingCard(tp,c80000499.filter3,tp,LOCATION_DECK,0,1,1,nil)
		g1:Merge(g2)
		g1:Merge(g3)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tg=g1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	g1:RemoveCard(tc)
	Duel.SendtoHand(g1,tp,REASON_EFFECT)
end
end
function c80000499.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80000499.thfilter(c)
	return c:IsSetCard(0x2d2) and c:IsAbleToHand()
end
function c80000499.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000499.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000499.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000499.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end