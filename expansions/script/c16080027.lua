--新津 艾琳娜
function c16080027.initial_effect(c)
	aux.AddSynchroProcedure(c,c16080027.tfilter,aux.NonTuner(c16080027.sfilter),1)
	c:EnableReviveLimit() 
	--cannot Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5ca))
	e1:SetValue(c16080027.indval)
	c:RegisterEffect(e1)
	--cannot attive
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCondition(c16080027.thcon)
	e2:SetOperation(c16080027.thop)
	c:RegisterEffect(e2)
	--spsumon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c16080027.spcon)
	e4:SetTarget(c16080027.sptg)
	e4:SetOperation(c16080027.spop)
	c:RegisterEffect(e4)
end
function c16080027.tfilter(c)
	return c:IsSetCard(0x5ca)
end
function c16080027.sfilter(c)
	return c:IsSetCard(0x5ca) and c:IsType(TYPE_SYNCHRO)
end
function c16080027.indval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c16080027.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and (c:IsPosition(POS_FACEUP_DEFENSE) and c:IsPreviousPosition(POS_FACEUP_ATTACK)) or (c:IsPosition(POS_FACEUP_ATTACK) and c:IsPreviousPosition(POS_FACEUP_DEFENSE)) 
end
function c16080027.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c16080027.aclimit1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c16080027.aclimit1(e,re,tp)
	return re:IsType(TYPE_EFFECT) and re:IsType(TYPE_MONSTER) and re:GetSummonLocation()==LOCATION_EXTRA and not re:GetHandler():IsImmuneToEffect(e) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c16080027.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK)
		and c:IsPreviousPosition(POS_FACEUP)
end
function c16080027.spfilter(c,e,tp)
	return c:IsSetCard(0x5ca) and c:IsLevelBelow(6) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16080027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16080027.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16080027.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16080027.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end