--我不是很好吃
function c1150009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150009+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c1150009.op1)
	c:RegisterEffect(e1)
--	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_ATTACK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1150010)
	e2:SetCondition(c1150009.con2)
	e2:SetCost(c1150009.cost2)
	e2:SetOperation(c1150009.op2)
	c:RegisterEffect(e2)
--
end
--
function c1150009.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsSSetable() then
		e:GetHandler():CancelToGrave()
		if Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)~=0 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			local e1_1=Effect.CreateEffect(e:GetHandler())
			e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_1:SetCode(EFFECT_DESTROY_REPLACE)
			e1_1:SetReset(RESET_EVENT+0x00040000+0x00080000+0x00100000+0x00200000+0x00400000+0x00800000+0x01000000+0x02000000+0x04000000+0x08000000+RESET_PHASE+PHASE_END,2)
			e1_1:SetTarget(c1150009.tg1_1)
			e1_1:SetValue(c1150009.val1_1)
			e1_1:SetOperation(c1150009.op1_1)
			Duel.RegisterEffect(e1_1,tp) 
		end
	end
end
--
--
function c1150009.tfilter1_1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) and not c:IsReason(REASON_REPLACE)
end
--
function c1150009.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1150009.tfilter1_1,1,nil,tp) and e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():IsFacedown() end
	return Duel.SelectYesNo(tp,aux.Stringid(1150009,0))
end
--
function c1150009.val1_1(e,c)
	return c1150009.tfilter1_1(c,e:GetHandlerPlayer())
end
--
function c1150009.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
--
function c1150009.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ph~=PHASE_MAIN2 and ph~=PHASE_END
		and Duel.IsExistingMatchingCard(Card.IsAttackable,tp,0,LOCATION_MZONE,1,nil)
end
function c1150009.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c1150009.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then return Duel.NegateAttack() end
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	e2_1:SetCountLimit(1)
	e2_1:SetOperation(c1150009.op2_1)
	Duel.RegisterEffect(e2_1,tp)
end
function c1150009.op2_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end





