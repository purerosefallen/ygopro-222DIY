--仙女的水滴·夏
function c1150023.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150023+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150023.tg1)
	e1:SetOperation(c1150023.op1)
	c:RegisterEffect(e1)  
--   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c1150023.con2)
	e2:SetTarget(c1150023.tg2)
	e2:SetOperation(c1150023.op2)
	c:RegisterEffect(e2) 
end
--
function c1150023.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,1150023,0,0,0)
	end
end
--
function c1150023.ofilter1(c)
	return c:IsAbleToHand() and c:IsCode(1150024)
end
function c1150023.ofilter01(c,e,tp)
	return c:GetLevel()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1150023.op1(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffect(tp,1150023)
	if flag==3 then
		local gn=Group.CreateGroup()
		e:GetHandler():CancelToGrave()
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			local tg=g:Filter(Card.IsCode,nil,1150023)
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
			local tg2=g2:Filter(Card.IsCode,nil,1150023)
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
			local tg3=g3:Filter(Card.IsCode,nil,1150023)
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
			local tg4=g4:Filter(Card.IsCode,nil,1150023)
			if tg4:GetCount()>0 then
				local tc4=tg4:GetFirst()
				while tc4 do
					gn:AddCard(tc4)
					tc4=tg4:GetNext()
				end
			end
		end
		if gn:GetCount()>0 then
			if Duel.Remove(gn,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1150023.ofilter01,tp,LOCATION_GRAVE,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
				Duel.BreakEffect() 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)   
				local g5=Duel.SelectMatchingCard(tp,c1150023.ofilter01,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
				if g5:GetCount()>0 then
					Duel.SpecialSummon(g5,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	else
		e:GetHandler():CancelToGrave()
		if Duel.SendtoDeck(e:GetHandler(),nil,2,POS_FACEDOWN)~=0 then
			Duel.ShuffleDeck(tp)
			if Duel.IsExistingMatchingCard(c1150023.ofilter1,tp,LOCATION_DECK,0,1,nil) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c1150023.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
--
function c1150023.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK 
end
--
function c1150023.tfilter2(c)
	return c:GetLevel()<5 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c1150023.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150023.tfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1150023.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1150023.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			local tc=g:GetFirst()   
			Duel.ConfirmCards(1-tp,g)
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetType(EFFECT_TYPE_FIELD)
			e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2_1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2_1:SetTargetRange(1,0)
			e2_1:SetValue(c1150023.limit2_1)
			e2_1:SetLabel(tc:GetOriginalCode())
			e2_1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2_1,tp)
		end
	end
end
--
function c1150023.limit2_1(e,re,tp)
	return re:GetHandler():GetOriginalCode()==e:GetLabel()
end
--

