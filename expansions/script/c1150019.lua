--苹果的房间
function c1150019.initial_effect(c)
--
	c:SetUniqueOnField(1,1,1150019)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c1150019.con1)
	e1:SetTarget(c1150019.tg1)
	e1:SetOperation(c1150019.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c1150019.con2)
	e2:SetTarget(c1150019.tg2)
	e2:SetOperation(c1150019.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c1150019.con3)
	e3:SetOperation(c1150019.op3)
	c:RegisterEffect(e3)
--
	if not c1150019.global_check then
		c1150019.global_check=true
		local e0_1=Effect.CreateEffect(c)
		e0_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0_1:SetCode(EVENT_CHAINING)
		e0_1:SetOperation(c1150019.op0_1)
		Duel.RegisterEffect(e0_1,0)
	end
--  
end
--
function c1150019.op0_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),1150019,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
--
function c1150019.con1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,1150019)+Duel.GetFlagEffect(1-tp,1150019))==3
end
--
function c1150019.tfilter1(c)
	return c:IsAbleToGrave()
end
function c1150019.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(c1150019.tfilter1,tp,LOCATION_DECK,0,2,nil) and Duel.IsExistingMatchingCard(c1150019.tfilter1,1-tp,0,LOCATION_DECK,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,1-tp,LOCATION_DECK) 
end
--
function c1150019.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g1=Duel.GetMatchingGroup(c1150019.tfilter1,tp,LOCATION_DECK,0,nil)	
		if g1:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local g2=g1:RandomSelect(1-tp,2,2,nil)
			if g2:GetCount()>0 then
				Duel.SendtoGrave(g2,REASON_EFFECT)
			end
		end
		local g3=Duel.GetMatchingGroup(c1150019.tfilter1,tp,0,LOCATION_DECK,nil)	
		if g3:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g4=g3:RandomSelect(tp,2,2,nil)
			if g4:GetCount()>0 then
				Duel.SendtoGrave(g4,REASON_EFFECT)
			end 
		end
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_1:SetRange(LOCATION_FZONE)
		e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1_1:SetValue(1)
		e:GetHandler():RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(e:GetHandler())
		e1_2:SetType(EFFECT_TYPE_FIELD)
		e1_2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_2:SetTargetRange(1,0)
		e1_2:SetValue(c1150019.limit1_2)
		e1_2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_2,tp)
		local e1_3=Effect.CreateEffect(e:GetHandler())
		e1_3:SetType(EFFECT_TYPE_FIELD)
		e1_3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_3:SetTargetRange(1,1)
		e1_3:SetValue(c1150019.limit1_3)
		e1_3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_3,tp)	
	end
end
--
function c1150019.limit1_2(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--
function c1150019.limit1_2(e,re,tp)
	return re:GetHandler():IsCode(73468603) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--
function c1150019.con2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,1150019)+Duel.GetFlagEffect(1-tp,1150019))==6
end
--
function c1150019.tfilter2(c)
	return c:IsAbleToGrave()
end
function c1150019.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(c1150019.tfilter2,tp,LOCATION_DECK,0,3,nil) and Duel.IsExistingMatchingCard(c1150019.tfilter2,tp,0,LOCATION_DECK,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,1-tp,LOCATION_DECK)  
end
--
function c1150019.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c1150019.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(1-tp,c1150019.tfilter2,tp,0,  LOCATION_DECK,1,1,nil)
		if g1:GetCount()>0 and g2:GetCount()>0 then
			if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 and Duel.SendtoGrave(g2,REASON_EFFECT)~=0 then
				local g3=Duel.GetMatchingGroup(c1150019.tfilter2,tp,LOCATION_DECK,0,nil)	
				if g3:GetCount()>1 then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
					local g4=g3:RandomSelect(1-tp,2,2,nil)
					if g4:GetCount()>0 then
						Duel.SendtoGrave(g4,REASON_EFFECT)
					end
				end
				local g5=Duel.GetMatchingGroup(c1150019.tfilter2,tp,0,LOCATION_DECK,nil)	
				if g5:GetCount()>1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g6=g5:RandomSelect(tp,2,2,nil)
					if g6:GetCount()>0 then
						Duel.SendtoGrave(g6,REASON_EFFECT)
					end
				end
			end 
		end
	end
end
--
function c1150019.con3(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,1150019)+Duel.GetFlagEffect(1-tp,1150019))==8
end
--
function c1150019.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local turnp=Duel.GetTurnPlayer()
		local tph=Duel.GetCurrentPhase()
		if tph==PHASE_DRAW then
			Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1) 
			Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
			Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			local e3_1=Effect.CreateEffect(e:GetHandler())
			e3_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3_1:SetType(EFFECT_TYPE_FIELD)
			e3_1:SetCode(EFFECT_CANNOT_BP)
			e3_1:SetTargetRange(1,0)
			e3_1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3_1,turnp)
		end
		if tph==PHASE_STANDBY then
			Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
			Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1) 
			local e3_2=Effect.CreateEffect(e:GetHandler())
			e3_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3_2:SetType(EFFECT_TYPE_FIELD)
			e3_2:SetCode(EFFECT_CANNOT_BP)
			e3_2:SetTargetRange(1,0)
			e3_2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3_2,turnp)
		end
		if tph==PHASE_MAIN1 then 
			Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
			Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)  
			local e3_3=Effect.CreateEffect(e:GetHandler())
			e3_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3_3:SetType(EFFECT_TYPE_FIELD)
			e3_3:SetCode(EFFECT_CANNOT_BP)
			e3_3:SetTargetRange(1,0)
			e3_3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3_3,turnp)
		end
		if tph>PHASE_MAIN1 and tph<PHASE_MAIN2 then 
			Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		end
		if tph==PHASE_MAIN2 then 
			Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		end
		Duel.BreakEffect()
		Duel.Recover(Duel.GetTurnPlayer(),1000,REASON_EFFECT)
	end
end
