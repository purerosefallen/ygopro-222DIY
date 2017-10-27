--Warpko 镜面宇宙
function c50000042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000042,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,50000042)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c50000042.sptg)
	e2:SetOperation(c50000042.spop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetDescription(aux.Stringid(50000042,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,50000042)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c50000042.thtg)
	e3:SetOperation(c50000042.thop)
	c:RegisterEffect(e3)  
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50000042,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,500000421)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c50000042.thtg1)
	e4:SetOperation(c50000042.thop1)
	c:RegisterEffect(e4)
end
-------------------TD--SP-------------------------------------------
function c50000042.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x50a) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c50000042.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c50000042.spfilter(c,e,tp)
	return c:IsSetCard(0x50a)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000042.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c50000042.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c50000042.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c50000042.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50000042.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50000042.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end
-------------------TD--TH--------------------------------------------
function c50000042.tdfilter(c,e,tp)
	return c:IsSetCard(0x50a)  and c:IsAbleToDeck()
end
function c50000042.thfilter(c,e,tp)
	return c:IsSetCard(0x50a)  and c:IsAbleToHand()
end
function c50000042.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000042.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c50000042.tdfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c50000042.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c50000042.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,c50000042.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 or g1:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
end
------------------------------------------
function c50000042.thfilter1(c)
	return c:IsSetCard(0x50a)  and not c:IsCode(50000042) and c:IsAbleToHand()
end
function c50000042.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000042.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000042.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000042.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end