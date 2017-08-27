--弱肉一击
function c10113029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113029+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10113029.cost)
	e1:SetTarget(c10113029.target)
	e1:SetOperation(c10113029.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(10113029,ACTIVITY_SPSUMMON,c10113029.counterfilter)	
end

function c10113029.counterfilter(c)
	return bit.band(c:GetType(),TYPE_EFFECT)==0
end
function c10113029.cfilter(c)
	return c:IsLevelAbove(4) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c10113029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(10113029,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c10113029.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10113029.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10113029.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c10113029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10113029.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10113029.spfilter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10113029.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10113029.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10113029.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(c:GetType(),TYPE_EFFECT)~=0
end