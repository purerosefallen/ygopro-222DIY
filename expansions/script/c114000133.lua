--念願の氷剣（アイスソード）
function c114000133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c114000133.condition)
	e1:SetTarget(c114000133.target)
	e1:SetOperation(c114000133.operation)
	c:RegisterEffect(e1)
end
function c114000133.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c114000133.filter(c)
	return c:IsFaceup() and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000133.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c114000133.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114000133.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c114000133.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c114000133.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Atkup
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Equip limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c114000133.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		--cannot be target
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD) --if TYPE_EQUIP, only equipped monster will be affected --> cannot target equipped monster
		e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(c114000133.tglimit)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e4:SetValue(c114000133.tgval)
		c:RegisterEffect(e4)
	end
end
function c114000133.eqlimit(e,c)
	return ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000133.tglimit(e,c)
	return e:GetHandler():GetEquipTarget()~=c --get the equiped target
end
function c114000133.tgval(e,re,rp)
	return e:GetHandlerPlayer()~=rp
end