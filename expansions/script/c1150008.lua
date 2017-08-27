--心之锁
function c1150008.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150008+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150008.tg1)
	e1:SetOperation(c1150008.op1)
	c:RegisterEffect(e1)   
--  
end
--
function c1150008.tfilter1(c)
	return c:IsAbleToGrave() and c:IsFaceup()
end
function c1150008.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150008.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1150008.tfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c1150008.tfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1150008.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local e1_4=Effect.CreateEffect(e:GetHandler())
	e1_4:SetType(EFFECT_TYPE_SINGLE)
	e1_4:SetCode(EFFECT_CANNOT_TRIGGER)
	e1_4:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_4,true)
	local e1_5=Effect.CreateEffect(e:GetHandler())
	e1_5:SetType(EFFECT_TYPE_SINGLE)
	e1_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_5:SetCode(EFFECT_CANNOT_ATTACK)
	e1_5:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_5,true)	
end





