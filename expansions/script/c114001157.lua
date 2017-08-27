--風の魚の夢
function c114001157.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,114001157+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c114001157.condition)
	e1:SetCost(c114001157.cost)
	e1:SetTarget(c114001157.target)
	e1:SetOperation(c114001157.activate)
	c:RegisterEffect(e1)
end
function c114001157.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114001157.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or not Duel.IsExistingMatchingCard(c114001157.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114001157.rmfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(5)
end
function c114001157.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001157.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114001157.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:GetFirst():RegisterFlagEffect(114001157,RESET_EVENT+0x1fe0000,0,1)
	e:SetLabelObject(g:GetFirst())
end
function c114001157.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp)
end
function c114001157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001157.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c114001157.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114001157,0))
	local tc=Duel.SelectMatchingCard(tp,c114001157.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--
		local mtc=e:GetLabelObject()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+0x1020000) --RESET_TOFIELD+RESET_TURN_SET
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetLabelObject(mtc)
		e1:SetCountLimit(1)
		e1:SetCondition(c114001157.thcon)
		e1:SetOperation(c114001157.thop)
		tc:RegisterEffect(e1)
		--
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function c114001157.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	return tc:IsAbleToHand() and tc:GetFlagEffect(114001157)~=0 
end
function c114001157.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc~=nil then Duel.Hint(HINT_CARD,0,114001157) end --show hint
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end