--新津 诛砂
function c16080024.initial_effect(c)
	c:EnableReviveLimit()
	--spsumon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16080024.spcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16080024)
	e2:SetCondition(c16080024.thcon)
	e2:SetTarget(c16080024.thtg)
	e2:SetOperation(c16080024.thop)
	c:RegisterEffect(e2)
end
function c16080024.filter(c)
	return c:IsSetCard(0x5ca) and c:IsLevelAbove(6) and c:IsFaceup()
end
function c16080024.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and Duel.IsExistingMatchingCard(c16080024.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c16080024.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and c:IsPosition(POS_FACEUP_DEFENSE) and c:IsPreviousPosition(POS_FACEUP_ATTACK)
end
function c16080024.disfilter(c,e)
	return c:IsFaceup()
end
function c16080024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16080024.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16080024.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c16080024.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c16080024.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end