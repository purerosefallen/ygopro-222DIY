--仙女的水滴·冬
function c1150024.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150024+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150024.tg1)
	e1:SetOperation(c1150024.op1)
	c:RegisterEffect(e1)  
--   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c1150024.con2)
	e2:SetTarget(c1150024.tg2)
	e2:SetOperation(c1150024.op2)
	c:RegisterEffect(e2) 
--
end
--
function c1150024.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,1150024,0,0,0)
	end
end
--
function c1150024.ofilter1(c)
	return c:IsAbleToGrave() and c:IsCode(1150023)
end
function c1150024.ofilter01(c)
	return c:IsAbleToGrave()
end
function c1150024.op1(e,tp,eg,ep,ev,re,r,rp)
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
			if Duel.Remove(gn,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1150024.ofilter01,tp,LOCATION_DECK,0,3,nil) then
				Duel.BreakEffect() 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)	 
				local g5=Duel.SelectMatchingCard(tp,c1150024.ofilter01,tp,LOCATION_DECK,0,3,3,nil)
				if g5:GetCount()>0 then
					Duel.SendtoGrave(g5,REASON_EFFECT)
				end
			end
		end
	else
		e:GetHandler():CancelToGrave()
		if Duel.SendtoDeck(e:GetHandler(),nil,2,POS_FACEDOWN)~=0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()	  
			local sel=1
			local cg=Duel.GetMatchingGroup(c1150024.ofilter1,tp,LOCATION_DECK,0,nil)
			if cg:GetCount()>0 then
				sel=Duel.SelectOption(tp,aux.Stringid(1150024,0),aux.Stringid(1150024,1))
			else
				sel=Duel.SelectOption(tp,aux.Stringid(1150024,1))+1
			end
			if sel==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=cg:Select(tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
			if sel==1 then
				Duel.Draw(tp,1,REASON_EFFECT)   
			end
		end
	end
end
--
function c1150024.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK 
end
--
function c1150024.tfilter2(c)
	return c:IsAbleToHand() and c:IsCode(1150023) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c1150024.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150024.tfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
--
function c1150024.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1150024.tfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
