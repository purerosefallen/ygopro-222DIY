--Net Ball
function c80000418.initial_effect(c)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000418,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,80000418+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c80000418.condition)
	e3:SetTarget(c80000418.target)
	e3:SetOperation(c80000418.operation)
	c:RegisterEffect(e3)	
end
function c80000418.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()~=tp and (c:IsReason(REASON_EFFECT) or (c:IsReason(REASON_BATTLE) and c==Duel.GetAttackTarget()))
end
function c80000418.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80000418.cfilter,1,nil,tp)
end
function c80000418.spfilter(c,e,tp,rac)
	return c:IsRace(rac) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x2d0)
end
function c80000418.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c80000418.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,RACE_INSECT)
		and Duel.IsExistingMatchingCard(c80000418.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,RACE_AQUA) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c80000418.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c80000418.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,RACE_INSECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c80000418.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,RACE_AQUA)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end