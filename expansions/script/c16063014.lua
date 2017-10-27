function c16063014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c16063014.spcon)
	e1:SetOperation(c16063014.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16063014,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,16063014)
	e3:SetCost(c16063014.cost)
	e3:SetTarget(c16063014.tg)
	e3:SetOperation(c16063014.op)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(16063014,ACTIVITY_SPSUMMON,c16063014.counterfilter)
end
function c16063014.sfilter(c)
	return   c:IsSetCard(0x5c5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c16063014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c16063014.sfilter,tp,LOCATION_HAND,0,1,c)
		and Duel.GetFlagEffect(tp,16063014)==0 
end
function c16063014.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c16063014.sfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,16063014,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16063014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16063014.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x5c5)
end
function c16063014.counterfilter(c)
	return c:IsSetCard(0x5c5)
end
function c16063014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16063014,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16063014.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16063014.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x5c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c16063014.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,16063014)==0 
		and Duel.IsExistingMatchingCard(c16063014.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16063014.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16063014.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,16063014,RESET_PHASE+PHASE_END,0,1)
end
end