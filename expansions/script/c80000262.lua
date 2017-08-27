--口袋妖怪 沙漠奈亚
function c80000262.initial_effect(c)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c80000262.indval)
	c:RegisterEffect(e5) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000262,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdogcon)
	e1:SetTarget(c80000262.sptg)
	e1:SetOperation(c80000262.spop)
	c:RegisterEffect(e1) 
	--wudi
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c80000262.con)
	e2:SetValue(c80000262.efilter)
	c:RegisterEffect(e2) 
end
function c80000262.indval(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000262.filter(c,e,tp)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_PLANT) and c:GetCode()~=80000262
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(3)
end
function c80000262.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80000262.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c80000262.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000262.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80000262.filter1(c)
	return c:IsFaceup() and c:IsCode(80000212)
end
function c80000262.con(e)
	return Duel.IsExistingMatchingCard(c80000262.filter1,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(80000212)
end
function c80000262.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end