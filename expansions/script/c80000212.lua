--沙雹
function c80000212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c80000212.adtg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)  
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c80000212.damcon2)
	e4:SetOperation(c80000212.damop2)
	c:RegisterEffect(e4) 
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(80000212,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(c80000212.condition)
	e5:SetTarget(c80000212.target)
	e5:SetOperation(c80000212.operation)
	c:RegisterEffect(e5)
	--Atk/def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTarget(c80000212.adtg1)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetValue(-400)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)	   
end
function c80000212.adtg(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c80000212.adtg1(e,c)
	return not c:IsRace(RACE_MACHINE) and not c:IsAttribute(ATTRIBUTE_EARTH)
end
function c80000212.cfilter1(c)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsRace(RACE_MACHINE))
end
function c80000212.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c80000212.cfilter1,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80000212.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
		Duel.Hint(HINT_CARD,0,80000212)
		Duel.Damage(p,500,REASON_EFFECT)
end
function c80000212.cfilter(c,tp)
	return bit.band(c:GetReason(),0x41)==0x41 and c:IsControler(tp) and c:IsRace(RACE_ROCK)
end
function c80000212.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80000212.cfilter,1,nil,tp)
end
function c80000212.spfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c80000212.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c80000212.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80000212.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	 Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
end