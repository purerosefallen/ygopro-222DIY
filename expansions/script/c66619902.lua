--AIW·爱丽丝的兔子
function c66619902.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c66619902.spcon)
	e1:SetCost(c66619902.cost)
	e1:SetTarget(c66619902.sptg)
	e1:SetOperation(c66619902.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c66619902.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:GetFirst():IsSetCard(0x666)
end
function c66619902.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c66619902.spfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(66619902)
end
function c66619902.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c66619902.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c66619902.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66619902.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end