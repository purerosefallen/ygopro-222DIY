--ex-JSG
function c80007018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80007018+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c80007018.target)
	e1:SetOperation(c80007018.activate)
	c:RegisterEffect(e1)
end
function c80007018.filter(c,e,tp)
	return c:IsSetCard(0x2d9) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c80007018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80007018.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80007018.ctfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE)
end
function c80007018.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SendtoGrave(g,REASON_EFFECT)
	g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	tg=Duel.SelectMatchingCard(tp,c80007018.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.BreakEffect()
	Duel.SpecialSummon(tg,0,tp,tp,false,true,POS_FACEUP)
	local lp=Duel.GetLP(tp)
	if lp<=ct*2000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-ct*2000)
	end
end