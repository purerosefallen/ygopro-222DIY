--LA SG Greed 席維
function c1200012.initial_effect(c)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200012,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1200012)
	e2:SetTarget(c1200012.sptg)
	e2:SetOperation(c1200012.spop)
	c:RegisterEffect(e2)
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200012,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1200012.ttarget)
	e1:SetOperation(c1200012.toperation)
	c:RegisterEffect(e1)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200012,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1)
	e3:SetCondition(c1200012.tgcon)
	e3:SetTarget(c1200012.tgtg)
	e3:SetOperation(c1200012.tgop)
	c:RegisterEffect(e3)
end
function c1200012.filter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1200012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and not c:IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(c1200012.filter,tp,LOCATION_GRAVE,0,1,c,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,0,0)
end
function c1200012.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g1=Duel.SelectMatchingCard(tp,c1200012.filter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
		if g1:GetCount()==0 then return end
		g1:AddCard(c)
		if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)==2 then
			local tc = g1:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				tc = g1:GetNext()
			end
			local sg=Duel.GetMatchingGroup(c1200012.extrafilter,tp,LOCATION_EXTRA,0,nil,g1,e,tp)
			if not sg or sg:GetCount()==0 or Duel.GetLocationCountFromEx(tp)<0 then 
				Duel.BreakEffect()
				Duel.SendtoGrave(g1,REASON_EFFECT)
				return 
			end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			if  tc:IsType(TYPE_FUSION) then
				Duel.SendtoDeck(g1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end
function c1200012.extrafilter(c,mg,e,tp)
	if not c:IsSetCard(0xfba) then return false end
	if c:IsType(TYPE_FUSION) then
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg)
	end
	return false
end
function c1200012.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfba) and not c:IsType(TYPE_TUNER)
end
function c1200012.ttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1200012.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200012.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1200012.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1200012.toperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c1200012.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsSetCard(0xfba)
end
function c1200012.tgfilter(c)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1200012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200012.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_REMOVED)
end
function c1200012.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1200012.tgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end