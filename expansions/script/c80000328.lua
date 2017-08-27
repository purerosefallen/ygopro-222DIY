--传说中的翱翔
function c80000328.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,80000328)
	e1:SetCost(c80000328.cost)
	e1:SetTarget(c80000328.target)
	e1:SetOperation(c80000328.activate)
	c:RegisterEffect(e1)
end
function c80000328.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c80000328.cfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and Duel.IsExistingMatchingCard(c80000328.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv+1,e,tp)
end
function c80000328.spfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsRace(RACE_WINDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x2d0)
end
function c80000328.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c80000328.cfilter,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c80000328.cfilter,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80000328.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000328.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv+1,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
