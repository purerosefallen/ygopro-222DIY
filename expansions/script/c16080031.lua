--新津 铃绪奈
function c16080031.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5ca),aux.NonTuner(Card.IsSetCard,0x5ca),1)
	c:EnableReviveLimit()
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(c16080031.distarget)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c16080031.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c16080031.effectfilter)
	c:RegisterEffect(e5)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16080031,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c16080031.spcon)
	e1:SetTarget(c16080031.sptg)
	e1:SetOperation(c16080031.spop)
	c:RegisterEffect(e1)
end
function c16080031.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c16080031.distarget(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c16080031.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c16080031.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x5ca) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c16080031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c16080031.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16080031.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16080031.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,true,POS_FACEUP)
end