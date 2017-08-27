--古老的薰香
function c1150016.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150016.tg1)
	e1:SetOperation(c1150016.op1)
	c:RegisterEffect(e1)   
--
end
--
function c1150016.tfilter1(c)
	return c:IsFaceup()
end
function c1150016.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150016.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1150016.tfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1150016.tfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1150016.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(e:GetHandler())
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_2:SetRange(LOCATION_MZONE)
		e1_2:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1_2:SetValue(c1150016.efilter1_2)
		tc:RegisterEffect(e1_2)
		Duel.BreakEffect()
		local e1_3=Effect.CreateEffect(e:GetHandler())
		e1_3:SetType(EFFECT_TYPE_FIELD)
		e1_3:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_3:SetTargetRange(LOCATION_MZONE,0)
		e1_3:SetReset(RESET_PHASE+PHASE_END)
		e1_3:SetValue(c1150016.efilter1_3)
		Duel.RegisterEffect(e1_3,tp)	 
	end
end
--
function c1150016.efilter1_2(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
--
function c1150016.efilter1_3(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
--