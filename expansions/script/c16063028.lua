--nuosili
function c16063028.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16063028.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16063028,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,16063028)
	e3:SetCondition(c16063028.spcon1)
	e3:SetTarget(c16063028.sptg)
	e3:SetOperation(c16063028.spop)
	c:RegisterEffect(e3)
end
function c16063028.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetMZoneCount(c:GetControler())>0
end
function c16063028.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063028.spfilter(c,e,tp)
	return c:IsCode(16063029) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16063028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c16063028.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16063028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16063028.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	   if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
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