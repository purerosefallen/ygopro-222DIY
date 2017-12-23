--尸飞球
function c13254080.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254080,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,13254080)
	e1:SetCondition(c13254080.spcon)
	e1:SetTarget(c13254080.sptg)
	e1:SetOperation(c13254080.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,23254080)
	e2:SetTarget(c13254080.tgtg)
	e2:SetOperation(c13254080.tgop)
	c:RegisterEffect(e2)
	
end
function c13254080.spfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
		and c:IsLevelBelow(1) and c:IsRace(RACE_FAIRY) and not c:IsCode(13254037)
end
function c13254080.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x356) and c:IsAbleToHand()
end
function c13254080.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13254080.spfilter,1,nil,tp)
end
function c13254080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13254080.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)~=1 then return end
		--cannot release
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e11:SetRange(LOCATION_MZONE)
		e11:SetCode(EFFECT_UNRELEASABLE_SUM)
		e11:SetValue(1)
		e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e11)
		local e12=e11:Clone()
		e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e12)
		local e13=Effect.CreateEffect(e:GetHandler())
		e13:SetType(EFFECT_TYPE_SINGLE)
		e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e13:SetValue(1)
		e13:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e13)
		local e14=e13:Clone()
		e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		c:RegisterEffect(e14)
		local e15=e13:Clone()
		e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e15)
		local e16=Effect.CreateEffect(e:GetHandler())
		e16:SetDescription(aux.Stringid(13254080,1))
		e16:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e16:SetType(EFFECT_TYPE_SINGLE)
		e16:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e16)
		if Duel.SelectYesNo(tp,aux.Stringid(13254080,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=Duel.SelectMatchingCard(tp,c13254080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c13254080.tgfilter(c)
	return c:IsCode(13254037) and c:IsAbleToGrave()
end
function c13254080.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254080.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c13254080.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c13254080.tgfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
