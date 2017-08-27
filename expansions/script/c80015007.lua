--反叛的兽战士 黄兽
function c80015007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80015007.spcon)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,80015007)
	e2:SetCost(c80015007.spcost)
	e2:SetTarget(c80015007.sptg)
	e2:SetOperation(c80015007.spop)
	c:RegisterEffect(e2)  
	Duel.AddCustomActivityCounter(80015007,ACTIVITY_SPSUMMON,c80015007.counterfilter)
end
function c80015007.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c80015007.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x32d7) and c:GetCode()~=80015007
end
function c80015007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c80015007.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c80015007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetCustomActivityCount(80015007,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80015007.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c80015007.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c80015007.spfilter(c,e,tp)
	return c:IsSetCard(0x32d7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetCode()~=80015007
end
function c80015007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c80015007.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c80015007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80015007.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end