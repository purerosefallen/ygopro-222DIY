--ELF·魔法精灵公主
function c1190012.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1190012)
	e1:SetCost(c1190012.cost1)
	e1:SetTarget(c1190012.tg1)
	e1:SetOperation(c1190012.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetCountLimit(1,1190062)
	e2:SetTarget(c1190012.tg2)
	e2:SetOperation(c1190012.op2)
	c:RegisterEffect(e2)	
end
--
c1190012.named_with_ELF=1
function c1190012.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190012.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c1190012.filter1(c)
	return c:IsCode(1191004) and c:IsAbleToHand()
end
function c1190012.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190012.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1190012.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1190012.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c1190012.filter2(c,e,tp)
	return c1190012.IsELF(c) and c:IsType(TYPE_MONSTER) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1190012.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>1
		and Duel.IsExistingMatchingCard(c1190012.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil,e,tp) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_HAND)
end
function c1190012.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1190012.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,nil,e,tp)
	if g:GetCount()>1 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Damage(1-tp,400,REASON_EFFECT)
	end
end