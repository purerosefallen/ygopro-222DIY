--ELF·威斯特
function c1190011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1190011)
	e1:SetCondition(c1190011.con1)
	e1:SetTarget(c1190011.tg1)
	e1:SetOperation(c1190011.op1)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1190011)
	e2:SetCondition(c1190011.con1)
	e2:SetTarget(c1190011.tg1)
	e2:SetOperation(c1190011.op1)
	c:RegisterEffect(e2) 
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,1190061)
	e3:SetCondition(c1190011.con3)
	e3:SetTarget(c1190011.tg3)
	e3:SetOperation(c1190011.op3)
	c:RegisterEffect(e3)	
--  
end
--
c1190011.named_with_ELF=1
function c1190011.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190011.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c1190011.tfilter(c)
	return c1190011.IsELF(c) and c:IsAbleToGrave() and not c:IsCode(1190011)
end
function c1190011.tgfilter(c)
	return c:IsCode(1191301) and c:IsAbleToHand()
end
function c1190011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190011.tfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.IsExistingMatchingCard(c1190011.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1190011.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1190011.tfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c1190011.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
--
function c1190011.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
--
function c1190011.filter2(c,e,tp)
	return c:IsCode(1190102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c1190011.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c1190011.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c1190011.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1190011.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
--
function c1190011.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

