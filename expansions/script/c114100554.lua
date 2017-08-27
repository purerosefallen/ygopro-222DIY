--★呪われたダンピール　ルーチュ
function c114100554.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114100554.condition)
	e1:SetTarget(c114100554.target)
	e1:SetOperation(c114100554.operation)
	c:RegisterEffect(e1)
end
function c114100554.filter(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114100554.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and not Duel.GetAttacker():IsDisabled() and Duel.GetAttacker():IsType(TYPE_EFFECT) and not Duel.IsExistingMatchingCard(c114100554.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c114100554.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
end
function c114100554.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)==0 then return end
	local at=Duel.GetAttacker()
	if at:IsControler(1-tp) and at:IsRelateToBattle() and at:IsFaceup() and not at:IsDisabled() then
		Duel.NegateRelatedChain(at,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		at:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		at:RegisterEffect(e2)
		--battle end
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
