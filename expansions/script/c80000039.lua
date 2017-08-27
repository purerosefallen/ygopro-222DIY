--口袋妖怪 水跃鱼
function c80000039.initial_effect(c)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000039,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCountLimit(1,80000039)
	e5:SetCondition(c80000039.spcon)
	e5:SetTarget(c80000039.sptg)
	e5:SetOperation(c80000039.spop)
	c:RegisterEffect(e5)
end
c80000039.lvupcount=1
c80000039.lvup={80000040}
function c80000039.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c80000039.filter(c,e,tp)
	return c:IsCode(80000040) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and (not c:IsLocation(LOCATION_GRAVE) or not c:IsHasEffect(EFFECT_NECRO_VALLEY))
end
function c80000039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000039.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c80000039.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000039.filter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
