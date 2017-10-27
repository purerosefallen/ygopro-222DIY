--ELF·精语者
function c1190002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,1190002)
	e1:SetTarget(c1190002.tg1)
	e1:SetOperation(c1190002.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
-- 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,1190052)
	e3:SetCost(c1190002.cost3)
	e3:SetTarget(c1190002.tg3)
	e3:SetOperation(c1190002.op3)
	c:RegisterEffect(e3)
end
--
c1190002.named_with_ELF=1
function c1190002.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190002.filter1(c,e,tp)
	return c1190002.IsELF(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_SYNCHRO)
end
function c1190002.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c1190002.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c1190002.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1190002.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
--
function c1190002.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--

function c1190002.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c1190002.filter3(c)
	return c:IsCode(1191002) and c:IsAbleToHand()
end
function c1190002.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190002.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1190002.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1190002.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
