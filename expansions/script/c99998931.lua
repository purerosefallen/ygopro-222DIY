--非法行为
function c99998931.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,99998931)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99998931.tg)
	e1:SetOperation(c99998931.op)
	c:RegisterEffect(e1)
end
function c99998931.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetAttack()>0
end
function c99998931.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99998931.filter(chkc)  and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c99998931.filter,tp,0,LOCATION_MZONE,1,nil) and  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c99998931.filter,tp,0,LOCATION_MZONE,1,1,nil)
  if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c99998931.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if  tc:IsFaceup() and tc:IsRelateToEffect(re) then
	  local e1=Effect.CreateEffect(e:GetHandler())
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_CANNOT_ATTACK)
	  e1:SetReset(RESET_EVENT+0x1fe0000)
	  tc:RegisterEffect(e1)
	 local e2=e1:Clone()
	 e2:SetCode(EFFECT_CANNOT_TRIGGER)
	 e2:SetValue(1)
	  tc:RegisterEffect(e2)
	   local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	   local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	   if g2:GetCount()>0 then
		local cg2=g2:GetFirst()
		while cg2 do
		 local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(-tc:GetAttack())
		e3:SetReset(RESET_EVENT+0x1fe0000)
		cg2:RegisterEffect(e3)
	   cg2=g2:GetNext()
 end
	  end
	   if g1:GetCount()>0 then
		local cg1=g1:GetFirst()
		while cg1 do
		 local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(tc:GetAttack())
		e4:SetReset(RESET_EVENT+0x1fe0000)
		cg1:RegisterEffect(e4)
	   cg1=g1:GetNext()
 end
end
end
end