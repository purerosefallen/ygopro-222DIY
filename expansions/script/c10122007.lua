--空想的境界限
function c10122007.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122007,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10122007+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10122007.cost)
	e1:SetTarget(c10122007.target)
	e1:SetOperation(c10122007.operation)
	c:RegisterEffect(e1)   
	--spsummon2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122007,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10122007+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10122007.cost2)
	e1:SetTarget(c10122007.target2)
	e1:SetOperation(c10122007.operation2)
	c:RegisterEffect(e1)	 
end

function c10122007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,3,nil,10122011) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,3,3,nil,10122011)
	Duel.Release(g,REASON_COST)
end

function c10122007.filter(c,e,tp)
	return c:IsCode(10122008) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c10122007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10122007.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end

function c10122007.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10122007.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end

function c10122007.cfilter(c)
	return c:IsSetCard(0xc333) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end

function c10122007.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122007.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,5,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c10122007.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10122007.filter2(c,e,tp)
	return c:IsCode(10122010) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c10122007.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10122007.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end

function c10122007.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10122007.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end