--可怜剑城
function c17060838.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060838,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,17060838)
	e1:SetCondition(c17060838.spcon)
	e1:SetTarget(c17060838.sptg)
	e1:SetOperation(c17060838.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060839,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c17060838.efcon)
	e3:SetOperation(c17060838.efop)
	c:RegisterEffect(e3)
end
c17060838.is_named_with_Fencing=1
c17060838.is_named_with_Million_Arthur=1
function c17060838.IsFencing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Fencing
end
function c17060838.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060838.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c17060838.IsMillion_Arthur(c) and not c:IsCode(17060838)
end
function c17060838.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17060838.cfilter,1,nil,tp)
end
function c17060838.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060838.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetMZoneCount(tp)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c17060838.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_XYZ)~=0
		and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:GetReasonCard():IsSetCard(0xff9f)
end
function c17060838.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(17060838,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c17060838.atkcon)
	e1:SetValue(c17060838.atkval)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c17060838.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c17060838.atkval(e,c)
	return e:GetHandler():GetAttack()*2
end
