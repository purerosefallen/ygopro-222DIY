--仙女的水滴·冬·异色
function c1150045.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150024+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150045.tg1)
	e1:SetOperation(c1150045.op1)
	c:RegisterEffect(e1)  
--   
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c1150045.con2)
	e2:SetTarget(c1150045.tg2)
	e2:SetOperation(c1150045.op2)
	c:RegisterEffect(e2) 
--  
end
--
function c1150045.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,1150024,0,0,0)
	end
end
--
function c1150045.op1(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffect(tp,1150024)
	if flag==3 then
		local gn=Group.CreateGroup()
		e:GetHandler():CancelToGrave()
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			local tg=g:Filter(Card.IsCode,nil,1150024)
			if tg:GetCount()>0 then
				local tc=tg:GetFirst()
				while tc do
					gn:AddCard(tc)
					tc=tg:GetNext()
				end
			end
		end
		if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 then
			local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
			local tg2=g2:Filter(Card.IsCode,nil,1150024)
			if tg2:GetCount()>0 then
				local tc2=tg2:GetFirst()
				while tc2 do
					gn:AddCard(tc2)
					tc2=tg2:GetNext()
				end
			end
		end
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
			local g3=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
			local tg3=g3:Filter(Card.IsCode,nil,1150024)
			if tg3:GetCount()>0 then
				local tc3=tg3:GetFirst()
				while tc3 do
					gn:AddCard(tc3)
					tc3=tg3:GetNext()
				end
			end
		end
		if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>0 then
			local g4=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
			local tg4=g4:Filter(Card.IsCode,nil,1150024)
			if tg4:GetCount()>0 then
				local tc4=tg4:GetFirst()
				while tc4 do
					gn:AddCard(tc4)
					tc4=tg4:GetNext()
				end
			end
		end
		if gn:GetCount()>0 then
			if Duel.Remove(gn,POS_FACEUP,REASON_EFFECT)~=0 then
				Duel.BreakEffect() 
				if Duel.SendtoDeck(e:GetHandler(),nil,2,POS_FACEDOWN)~=0 then
					Duel.ShuffleDeck(tp)
					local e1_1=Effect.CreateEffect(e:GetHandler())
					e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1_1:SetCode(1150045)
					e1_1:SetCountLimit(1)
					e1_1:SetCondition(c1150045.con1_1)
					e1_1:SetOperation(c1150045.op1_1)
					e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					Duel.RegisterEffect(e1,tp)
					if not c1150045.global_check then
						c1150045.global_check=true
						c1150045[0]=0
						c1150045[1]=0
						local ge1=Effect.CreateEffect(c)
						ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						ge1:SetCode(EVENT_SUMMON_SUCCESS)
						ge1:SetOperation(c1150045.checkop1_1)
						Duel.RegisterEffect(ge1,0)
						local ge2=Effect.CreateEffect(c)
						ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
						ge2:SetOperation(c1150045.checkop1_1)
						Duel.RegisterEffect(ge2,0)
						local ge3=Effect.CreateEffect(c)
						ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
						ge3:SetOperation(c1150045.checkop1_1)
						Duel.RegisterEffect(ge3,0)
					end
				end
			end
		end
	else
		e:GetHandler():CancelToGrave()
		if Duel.SendtoDeck(e:GetHandler(),nil,2,POS_FACEDOWN)~=0 then
			Duel.ShuffleDeck(tp)
			if Duel.IsExistingMatchingCard(c1150045.ofilter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c1150045.ofilter1x,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1150045,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,c1150045.ofilter1,tp,LOCATION_HAND,0,1,1,nil)
				if g:GetCount()>0 then
					if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g2=Duel.SelectMatchingCard(tp,c1150045.ofilter1x,tp,LOCATION_DECK,0,1,1,nil)
						if g2:GetCount()>0 then
							Duel.SendtoGrave(g2,REASON_EFFECT)
						end
					end
				end
			end
		end
	end
end
function c1150045.ofilter1(c)
	return c:IsDiscardable()
end
function c1150045.ofilter1x(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER)
end
--
function c1150045.checkop1_1(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if Duel.GetTurnCount()~=c1150045[2] then
		c1150045[0]=0
		c1150045[1]=0
		c1150045[2]=Duel.GetTurnCount()
	end
	local tc=eg:GetFirst()
	local p1=false
	while tc do
		if tc:GetSummonPlayer()==turnp then p1=true end
		tc=eg:GetNext()
	end
	if p1 then
		c1150045[turnp]=c1150045[turnp]+1
		if c1150045[turnp]==3 then
			Duel.RaiseEvent(e:GetHandler(),1150045,e,0,0,0,0)
		end
	end
end
--
function c1150045.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c1150045.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1150045)
	local turnp=Duel.GetTurnPlayer()
	local tph=Duel.GetCurrentPhase()
	if tph==PHASE_DRAW then
		Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph==PHASE_STANDBY then
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)   
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph==PHASE_MAIN1 then 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)   
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph>PHASE_MAIN1 and tph<PHASE_MAIN2 then 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
	if tph==PHASE_MAIN2 then 
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
--
function c1150045.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK 
end
--
function c1150045.tfilter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function c1150045.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150045.tfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1150045.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1150045.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CANNOT_TRIGGER)
			e2_1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2_1)
		end
	end
end

