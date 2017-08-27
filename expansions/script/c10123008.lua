--夏恋·夜宴
function c10123008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10123008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10123008.cost)
	e1:SetTarget(c10123008.target)
	e1:SetOperation(c10123008.activate)
	c:RegisterEffect(e1)	
end
function c10123008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10123008.filter1(c,e,tp)
	return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c10123008.filter2,tp,LOCATION_GRAVE,0,1,c,c:GetLevel(),e,tp,c) and c:IsType(TYPE_TUNER) and c:IsSetCard(0x5334)
end
function c10123008.filter2(c,lv,e,tp,rc)
	return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c10123008.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,c,c:GetLevel()+lv,e,tp,rc) and c:IsNotTuner() and c:IsRace(RACE_SPELLCASTER)
end
function c10123008.filter3(c,lv,e,tp,rc)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true) and c~=rc and c:IsRace(RACE_SPELLCASTER)
end
function c10123008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10123008.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rc1=Duel.SelectMatchingCard(tp,c10123008.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rg=Duel.SelectMatchingCard(tp,c10123008.filter2,tp,LOCATION_GRAVE,0,1,1,rc1,rc1:GetLevel(),e,tp,rc)
	e:SetLabel(rg:GetFirst():GetLevel()+rc1:GetLevel())
	rg:AddCard(rc1)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c10123008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10123008.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,lv,e,tp,nil)
	if g:GetCount()>0 then 
	   Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
	end
end
