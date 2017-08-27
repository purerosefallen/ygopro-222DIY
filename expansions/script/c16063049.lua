function c16063049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c16063049.tg)
	e2:SetOperation(c16063049.op)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c16063049.descon)
	--e5:SetTarget(c16063049.destg)
	e5:SetOperation(c16063049.desop)
	c:RegisterEffect(e5)
	local e3=e5:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e5:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
	local e6=e5:Clone()
	e6:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e6)
end
function c16063049.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16063049.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		local f1=GetAttacker()
		local f2=GetGetAttackTarget()
		if f1:IsFaceup() and f1:IsLocation(LOCATION_MOZNE)  then
		Duel.Recover(f1:GetControler(),800,REASON_EFFECT)
		end
		if f2:IsFaceup() and f2:IsLocation(LOCATION_MOZNE) then
		Duel.Recover(f2:GetControler(),800,REASON_EFFECT)
		end
		if f1:IsPreviousLocation(LOCATION_MZONE) and f2:IsPreviousLocation(LOCATION_MZONE) and f1:IsReason(REASON_BATTLE) and f2:IsReason(REASON_BATTLE) then
		Duel.Recover(f1:GetControler(),800,REASON_EFFECT)
		Duel.Recover(f2:GetControler(),800,REASON_EFFECT)
		else if f1:IsPreviousLocation(LOCATION_MZONE) and f2:IsPreviousLocation(LOCATION_MZONE) and f1:IsReason(REASON_BATTLE) and not f2:IsReason(REASON_BATTLE) then
		Duel.Recover(f2:GetControler(),800,REASON_EFFECT)
		else
		Duel.Recover(f1:GetControler(),800,REASON_EFFECT)
		end
end
end
function c16063049.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c16063049.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=c:GetReasonPlayer()
	Duel.SetTargetPlayer(c:GetReasonPlayer())
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,c:GetPreviousControler(),4000)
end
function c16063049.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end