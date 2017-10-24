--纸上台本 「蓝宝石的存在证明」
function c10970005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,10970001+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10970005.atg)
	c:RegisterEffect(e1)  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1233))
	e3:SetValue(1)
	c:RegisterEffect(e3)  
	local e4=e3:Clone()
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10970005.condition0)
	c:RegisterEffect(e4)  
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10970005,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_FZONE)
	e5:SetHintTiming(0,0x1c0)
	e5:SetCondition(c10970005.condition)
	e5:SetTarget(c10970005.sptg)
	e5:SetOperation(c10970005.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c10970005.condition2)
	e6:SetOperation(c10970005.spop2)
	c:RegisterEffect(e6) 
end
function c10970005.atg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end 
   if c10970005.condition(e,tp,eg,ep,ev,re,r,rp,0) and c10970005.sptg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		c10970005.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c10970005.spop)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10970005.condition0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10970008)
end
function c10970005.filter(c)
	return c:IsFaceup() and c:IsCode(10970003)
end
function c10970005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10970005.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c10970005.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10970005.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,10970008)
end
function c10970005.spfilter(c,e,tp)
	return c:IsSetCard(0x1233) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10970005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10970005)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10970005.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.RegisterFlagEffect(tp,10970005,RESET_PHASE+PHASE_END,0,1)
end
function c10970005.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10970005.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10970005.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10970005.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end