--反射盾
function c10113035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10113035.target)
	e1:SetOperation(c10113035.activate)
	c:RegisterEffect(e1)	
end
function c10113035.filter(c)
	return c:IsFaceup() and c:IsAttackBelow(2000) and c:GetFlagEffect(10113035)==0
end
function c10113035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10113035.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113035.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10113035.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10113035.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(10113035)==0 then
		   tc:RegisterFlagEffect(10113035,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		   e1:SetCode(EVENT_BATTLE_START)
		   e1:SetCondition(c10113035.descon)
		   e1:SetOperation(c10113035.desop)
		   e1:SetRange(LOCATION_MZONE)
		   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		   tc:RegisterEffect(e1)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		   e2:SetCode(EVENT_CHAIN_SOLVING)
		   e2:SetRange(LOCATION_MZONE)
		   e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		   e2:SetOperation(c10113035.disop)
		   tc:RegisterEffect(e2)
		   local e3=Effect.CreateEffect(c)
		   e3:SetType(EFFECT_TYPE_FIELD)
		   e3:SetCode(EFFECT_DISABLE)
		   e3:SetRange(LOCATION_MZONE)
		   e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		   e3:SetTarget(c10113035.distg)
		   tc:RegisterEffect(e3)
		end
	end
end
function c10113035.distg(e,c)
	if c:GetCardTargetCount()==0 then return false end
	return c:GetCardTarget():IsContains(e:GetHandler())
end
function c10113035.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			Duel.NegateEffect(ev)
		end
	end
end
function c10113035.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end