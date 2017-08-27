--試練の儀式
function c114000364.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c114000364.cost)
	e1:SetOperation(c114000364.activate)
	c:RegisterEffect(e1)
end
function c114000364.cfilter(c)
	return not c:IsPublic() and c:IsLevelBelow(4)
	and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) --0x224
	or c:IsSetCard(0xcabb) ) 
end
function c114000364.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
	and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000364.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c114000364.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c114000364.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingTarget(c114000364.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c114000364.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c114000364.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c114000364.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local code=e:GetLabel()
		--sp summon
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c114000364.effcon)
		e1:SetOperation(c114000364.effop)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c114000364.spfilter(c,code,e,tp)
	return c:IsType(TYPE_MONSTER)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and c:GetCode()==code
end
function c114000364.effcon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return Duel.IsExistingMatchingCard(c114000364.spfilter,tp,LOCATION_HAND,0,1,nil,code,e,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c114000364.effop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if Duel.SelectYesNo(tp,aux.Stringid(114000364,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c114000364.spfilter,tp,LOCATION_HAND,0,1,1,nil,code,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end