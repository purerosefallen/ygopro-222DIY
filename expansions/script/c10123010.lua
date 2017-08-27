--夏恋·花火
function c10123010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_SSET+TIMING_END_PHASE)
	e1:SetCountLimit(1,10123010+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10123010.condition)
	e1:SetCost(c10123010.cost)
	e1:SetTarget(c10123010.target)
	e1:SetOperation(c10123010.activate)
	c:RegisterEffect(e1)	
end
function c10123010.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c10123010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10123010.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10123010.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10123010.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsPublic()
end
function c10123010.filter1(c,e)
	return c:IsFacedown() and c:IsDestructable() and c:IsCanBeEffectTarget(e)
end
function c10123010.filter2(c,e)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c10123010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(c10123010.filter1,tp,0,LOCATION_SZONE,nil,e)
	local g2=Duel.GetMatchingGroup(c10123010.filter2,tp,LOCATION_MZONE,0,nil,e)
	if chkc then return (chkc:IsLocation(LOCATION_SZONE) and chkc:IsDestructable() and chkc:IsControler(1-tp) and chkc:IsFacedown()) or (chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsRace(RACE_SPELLCASTER) and chkc:IsAttribute(ATTRIBUTE_WIND)) end
	if chk==0 then return g1:GetCount()>0 or g2:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
	  op=Duel.SelectOption(tp,aux.Stringid(10123010,0),aux.Stringid(10123010,1))
	elseif g1:GetCount()<=0 then
	  op=Duel.SelectOption(tp,aux.Stringid(10123010,1))
	  op=1
	else
	  op=Duel.SelectOption(tp,aux.Stringid(10123010,0))
	end
	  e:SetLabel(op+1)
	  local g=nil
	  if op==0 then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		 g=Duel.SelectTarget(tp,c10123010.filter1,tp,0,LOCATION_SZONE,1,1,nil,e)
		 Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_SZONE)
	  else
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		 g=Duel.SelectTarget(tp,c10123010.filter2,tp,LOCATION_MZONE,0,1,1,nil,e)
	  end
end
function c10123010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==1 and tc:IsFacedown() then
	   Duel.Destroy(tc,REASON_EFFECT)
	elseif e:GetLabel()==2 and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c10123010.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c10123010.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end