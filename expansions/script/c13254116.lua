--壁玉杖·守护星
function c13254116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,13254116)
	e1:SetCondition(c13254116.condition)
	e1:SetTarget(c13254116.target)
	e1:SetOperation(c13254116.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c13254116.eqlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCountLimit(1,13254116)
	e3:SetCondition(c13254116.condition2)
	e3:SetOperation(c13254116.activate2)
	c:RegisterEffect(e3)
	
end
function c13254116.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c13254116.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254116.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c13254116.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254116.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c13254116.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c13254116.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
	end
	if Duel.SelectYesNo(tp,aux.Stringid(13254116,0)) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetValue(c13254116.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e4:SetTargetRange(LOCATION_MZONE,0)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
		
end
function c13254116.eqlimit(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254116.efilter(e,te)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and (not g or not g:IsContains(c))
end
function c13254116.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local d=Duel.GetAttackTarget()
	return tc and d and d:IsFaceup() and d:IsControler(tp) and d:IsRace(RACE_FAIRY) and d:IsLevelBelow(1)
end
function c13254116.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if c:IsRelateToEffect(e) and d and d:IsFaceup() and d:IsRelateToBattle() then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(c13254116.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		d:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e4:SetTargetRange(LOCATION_MZONE,0)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		d:RegisterEffect(e4)
	end
end
