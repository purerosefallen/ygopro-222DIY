--实在魔瑟
function c17060866.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate+copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060866,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c17060866.necost)
	e1:SetTarget(c17060866.netg)
	e1:SetOperation(c17060866.neop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060866,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,17060866)
	e2:SetCondition(c17060866.pencon)
	e2:SetTarget(c17060866.pentg)
	e2:SetOperation(c17060866.penop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060866,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,17060866+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c17060866.sptcon)
	e3:SetTarget(c17060866.spttg)
	e3:SetOperation(c17060866.sptop)
	c:RegisterEffect(e3)
end
c17060866.is_named_with_Magic_Factions=1
c17060866.is_named_with_Million_Arthur=1
function c17060866.IsMagic_Factions(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Magic_Factions
end
function c17060866.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060866.copyfilter(c)
	return c:IsFaceup()
end
function c17060866.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(17060866)==0 end
	e:GetHandler():RegisterFlagEffect(17060866,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c17060866.netg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and c17060866.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060866.copyfilter,tp,LOCATION_PZONE,LOCATION_PZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c17060866.copyfilter,tp,LOCATION_PZONE,LOCATION_PZONE,1,1,nil)
end
function c17060866.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local code1=tc:GetOriginalCode()
		c:CopyEffect(code1,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end

function c17060866.pencon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c17060866.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060866.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060866.pcfilter(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingTarget(c17060866.pcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c17060866.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060866.penop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c17060866.sptcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_SZONE
end
function c17060866.spttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17060867,0,0x4011,0,0,1,RACE_PSYCHO,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c17060866.sptop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)
		or Duel.GetMZoneCount(tp)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,17060867,0,0x4011,0,0,1,RACE_PSYCHO,ATTRIBUTE_FIRE) then return end
	local token=Duel.CreateToken(tp,17060867)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(TYPE_TUNER)
	token:RegisterEffect(e1)
end