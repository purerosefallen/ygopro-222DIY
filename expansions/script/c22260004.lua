--逆境奋起 球磨川禊
function c22260004.initial_effect(c)
	c:SetUniqueOnField(1,0,22260004)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22260004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,22260004)
	e2:SetCondition(c22260004.spcon)
	e2:SetTarget(c22260004.sptg)
	e2:SetOperation(c22260004.spop)
	c:RegisterEffect(e2)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(c22260004.atkfilter))
	e2:SetValue(c22260004.atkval)
	c:RegisterEffect(e2)
	--spsummontoken
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22260004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c22260004.spttg)
	e2:SetOperation(c22260004.sptop)
	c:RegisterEffect(e2)
end
c22260004.named_with_KuMaKawa=1
function c22260004.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22260004.spfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:GetBaseAttack()==0 and c:IsType(TYPE_MONSTER)
end
function c22260004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22260004.spfilter,1,nil,tp)
end
function c22260004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22260004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22260004.atkfilter(c)
	return c:IsFaceup() and c22260004.IsKuMaKawa(c)
end
function c22260004.atkval(e,c)
	local tp=e:GetHandler():GetControler()
	local val=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	return math.max(0,val)
end
function c22260004.spttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,22269999,nil,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22260004.sptop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,22269999,nil,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,22269999)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end