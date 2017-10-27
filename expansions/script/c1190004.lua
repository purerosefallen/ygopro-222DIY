--ELF·莉莎
function c1190004.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1190004)
	e1:SetTarget(c1190004.tg1)
	e1:SetOperation(c1190004.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1190054)
	e2:SetCondition(c1190004.con2)
	e2:SetTarget(c1190004.tg2)
	e2:SetOperation(c1190004.op2)
	c:RegisterEffect(e2)	
end
--
c1190004.named_with_ELF=1
function c1190004.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190004.tfilter(c)
	return c1190004.IsELF(c) and c:IsAbleToGrave()
end
function c1190004.tgfilter(c)
	return c:IsCode(1191003) and c:IsAbleToHand()
end
function c1190004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190004.tfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.IsExistingMatchingCard(c1190004.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1190004.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1190004.tfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c1190004.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
--
function c1190004.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c1190004.filter2(c,e,tp)
	return c:IsCode(1190014) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1190004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1190004.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c1190004.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1190004.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT)
		e1:SetValue(c1190004.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_OPPO_TURN,1)
		tc:RegisterEffect(e1)		
	end
end
function c1190004.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end