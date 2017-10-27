--铁血人形-刽子手
function c2120002.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c2120002.aclimit)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c2120002.rmtg)
	e3:SetOperation(c2120002.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(2120002,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c2120002.spcon2)
	e5:SetTarget(c2120002.sptg2)
	e5:SetOperation(c2120002.spop2)
	c:RegisterEffect(e5)
end
function c2120002.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE and not re:GetHandler():IsImmuneToEffect(e)
end
function c2120002.rmfilter(c)
	return c:IsAbleToRemove()
end
function c2120002.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c2120002.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2120002.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c2120002.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c2120002.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_REMOVED,LOCATION_REMOVED)*200
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function c2120002.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c2120002.spfilter2(c,e,tp)
	return c:IsCode(2120001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2120002.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c2120002.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c2120002.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2120002.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end