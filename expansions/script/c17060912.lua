--真矢
function c17060912.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060912,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c17060912.spcon)
	e1:SetTarget(c17060912.sptg)
	e1:SetOperation(c17060912.spop)
	c:RegisterEffect(e1)
end
c17060912.is_named_with_Waves_Type=1
function c17060912.IsWaves_Type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Waves_Type
end
function c17060912.cfilter(c)
	return c:IsFaceup() and c:IsCode(17060911)
end
function c17060912.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17060912.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c17060912.filter(c,e,tp)
	return c:IsCode(17060913) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060912.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c17060912.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c17060912.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060912.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end