--巨大战舰 泡核（D）
function c13257214.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,1)
	e1:SetCondition(c13257214.spcon)
	e1:SetOperation(c13257214.spop)
	c:RegisterEffect(e1)
	--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCost(c13257214.spcost)
	e3:SetOperation(c13257214.spcop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(c13257214.indct)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(c13257214.bgmop)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	Duel.AddCustomActivityCounter(13257214,ACTIVITY_NORMALSUMMON,c13257214.counterfilter)
	Duel.AddCustomActivityCounter(13257214,ACTIVITY_SPSUMMON,c13257214.counterfilter)
	
end
function c13257214.counterfilter(c)
	return c:IsSetCard(0x353)
end
function c13257214.spfilter(c,ft)
	return c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c13257214.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c13257214.spfilter,tp,0,LOCATION_MZONE,1,nil,ft)
end
function c13257214.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13257214.spfilter,tp,0,LOCATION_MZONE,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13257214.spcost(e,c,tp)
	return Duel.GetCustomActivityCount(13257214,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(13257214,tp,ACTIVITY_NORMALSUMMON)==0
end
function c13257214.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13257214.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c13257214.splimit(e,c)
	return not c:IsSetCard(0x353)
end
function c13257214.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257214,4))
end
function c13257214.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
