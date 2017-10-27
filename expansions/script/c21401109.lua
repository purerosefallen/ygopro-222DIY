--玛修·基列莱特
function c21401109.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21401109)
	e1:SetCost(c21401109.thcost)
	e1:SetTarget(c21401109.thtg)
	e1:SetOperation(c21401109.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21401109)
	e2:SetCondition(c21401109.spcon)
	e2:SetTarget(c21401109.sptg)
	e2:SetOperation(c21401109.spop)
	c:RegisterEffect(e2)
end
function c21401109.thfilter(c)
	return (c:IsCode(21401101) or c:IsCode(21401130)) and c:IsAbleToHand()
end
function c21401109.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401109.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21401109.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD)
end
function c21401109.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21401109.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21401109.cfilter(c)
	return c:IsFaceup() and c:IsCode(21401101)
end
function c21401109.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21401109.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21401109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21401109.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c21401109.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end