--魔法少女へのスピンオフ
function c114000352.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c114000352.target)
	e1:SetOperation(c114000352.activate)
	c:RegisterEffect(e1)
end
function c114000352.filter(c,e,tp)
	local code=c:GetOriginalCode() --X c:GetCode()
	--ref: Vulcan the Divine VS Phantom of Chaos (code changed) (12/12/24)
	return c:IsFaceup() and c:IsAbleToHand() 
	and Duel.IsExistingMatchingCard(c114000352.spfilter,tp,LOCATION_HAND,0,1,nil,code,e,tp)
end
function c114000352.spfilter(c,code,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and c:IsType(TYPE_MONSTER)
	and c:GetCode()~=code
	and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) --0x224 
	or c:IsSetCard(0xcabb) ) 
end
function c114000352.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c114000352.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c114000352.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c114000352.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c114000352.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ShuffleHand(tc:GetControler())
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c114000352.spfilter,tp,LOCATION_HAND,0,1,1,nil,code,e,tp)
			Duel.SpecialSummon(g,202,tp,tp,false,false,POS_FACEUP)
		end
	end
end