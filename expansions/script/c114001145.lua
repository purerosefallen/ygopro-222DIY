--ソイレントシステム
function c114001145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114001145,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c114001145.destg)
	e2:SetOperation(c114001145.desop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(114001145,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,114001145)
	e3:SetCost(c114001145.cost)
	e3:SetOperation(c114001145.operation)
	c:RegisterEffect(e3)
end

function c114001145.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local py=Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,py,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c114001145.sgfilter(c)
	return c:IsSetCard(0x221) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c114001145.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local py=Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,py,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	local tg=g:Select(py,1,1,nil)
	if Duel.Destroy(tg,REASON_EFFECT)~=0 then
		local sg=Duel.GetMatchingGroup(c114001145.sgfilter,py,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then
			if Duel.SelectYesNo(py,aux.Stringid(114001145,2)) then
				local tsg=sg:Select(py,1,1,nil)
				Duel.SendtoHand(tsg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-py,tsg)
			end
		end
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,py,LOCATION_MZONE,LOCATION_MZONE,nil)
		if mg:GetCount()>0 then Duel.BreakEffect() end
		local tc=mg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=mg:GetNext()
		end
	end
end
function c114001145.cffilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c114001145.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(c114001145.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c114001145.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c114001145.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c114001145.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c114001145.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c114001145.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c114001145.filter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c114001145.drop1(e,tp,eg,ep,ev,re,r,rp)
	if (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)) then
		if eg:IsExists(c114001145.filter,1,nil,1-tp) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if eg:IsExists(c114001145.filter,1,nil,tp) then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
--
function c114001145.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS) then
		if eg:IsExists(c114001145.filter,1,nil,1-tp) then
			Duel.RegisterFlagEffect(tp,114001145,RESET_CHAIN,0,1)
		end
		if eg:IsExists(c114001145.filter,1,nil,tp) then
			Duel.RegisterFlagEffect(1-tp,114001145,RESET_CHAIN,0,1)
		end
	end
end
function c114001145.drop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,114001145)>0 then
		local n=Duel.GetFlagEffect(tp,114001145)
		Duel.ResetFlagEffect(tp,114001145)
		Duel.Draw(tp,n,REASON_EFFECT)
	end
	if Duel.GetFlagEffect(1-tp,114001145)>0 then
		local n=Duel.GetFlagEffect(1-tp,114001145)
		Duel.ResetFlagEffect(1-tp,114001145)
		Duel.Draw(1-tp,n,REASON_EFFECT)
	end
end
