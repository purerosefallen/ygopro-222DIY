function c16063025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5c5),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16063025,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c16063025.spcon)
	e1:SetTarget(c16063025.sptg)
	e1:SetOperation(c16063025.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16063004,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c16063025.rectg)
	e2:SetOperation(c16063025.recop)
	c:RegisterEffect(e2)
end
function c16063025.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c16063025.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x5c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c16063025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c16063025.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c16063025.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16063025.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,true,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c16063025.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c16063025.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c16063025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c16063025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c16063025.recop(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(c16063025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetAttack)
	Duel.Recover(tp,g:GetFirst():GetAttack(),REASON_EFFECT)
end