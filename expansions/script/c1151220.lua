--『绯色命运』
function c1151220.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151220+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1151220.tg1)
	e1:SetOperation(c1151220.op1)
	c:RegisterEffect(e1)	
--   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1151221)
	e2:SetCondition(c1151220.con2)
	e2:SetCost(c1151220.cost2)
	e2:SetOperation(c1151220.op2)
	c:RegisterEffect(e2)
--   
end
--
function c1151220.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151220.named_with_Leisp=1
function c1151220.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151220.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if chk==0 then return tc end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1151220,3))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
--
function c1151220.ofilter1(c)
	return c:IsAbleToGrave() and c1151220.IsLeimi(c)
end
function c1151220.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc then
		local t=0
		local opt=e:GetLabel()
		if opt==0 then t=TYPE_MONSTER 
		else 
			if opt==1 then t=TYPE_SPELL 
			else t=TYPE_TRAP 
			end
		end
		Duel.ConfirmDecktop(tp,1)
		if tc:IsType(t) and tc:IsAbleToHand() then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end 
		if not tc:IsType(t) and tc:IsAbleToGrave() then
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1151220.ofilter1,tp,LOCATION_DECK,0,1,nil) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)			
				local g=Duel.SelectMatchingCard(tp,c1151220.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoGrave(g,nil,REASON_EFFECT)
				end
			end
		end
	end
end
--
function c1151220.con2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ph~=PHASE_MAIN2 and ph~=PHASE_END
end
--
function c1151220.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1151220.cfilter2(c)
	return c1151220.IsLeimi(c)
end
function c1151220.cfilter2x1(c)
	return c:IsRace(RACE_FIEND)
end
function c1151220.cfilter2x2(c)
	return c1151220.IsLeimi(c) and c:IsAbleToHand()
end
function c1151220.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151220.cfilter2,tp,LOCATION_DECK,0,1,nil) or (Duel.CheckReleaseGroup(tp,c1151220.tfilter2x1,1,nil) and Duel.IsExistingMatchingCard(c1151220.cfilter2x2,tp,LOCATION_GRAVE,0,1,nil)) end
end
--
function c1151220.ofilter2(c)
	return c1151220.IsLeimi(c)
end
function c1151220.ofilter2x1(c)
	return c:IsRace(RACE_FIEND)
end
function c1151220.ofilter2x2(c)
	return c1151220.IsLeimi(c)
end
function c1151220.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1151220.cfilter2,tp,LOCATION_DECK,0,1,nil) and not (Duel.CheckReleaseGroup(tp,c1151220.tfilter2x1,1,nil) and Duel.IsExistingMatchingCard(c1151220.cfilter2x2,tp,LOCATION_GRAVE,0,1,nil)) then
		local sel=Duel.SelectOption(tp,aux.Stringid(1151220,0))
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1151220,2))
			local g=Duel.SelectMatchingCard(tp,c1151220.ofilter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.ShuffleDeck(tp)
				Duel.MoveSequence(tc,0)
				Duel.ConfirmDecktop(tp,1)
			end
		end
	end
	if Duel.IsExistingMatchingCard(c1151220.cfilter2,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckReleaseGroup(tp,c1151220.tfilter2x1,1,nil) and Duel.IsExistingMatchingCard(c1151220.cfilter2x2,tp,LOCATION_GRAVE,0,1,nil)) then
		local sel=Duel.SelectOption(tp,aux.Stringid(1151220,0),aux.Stringid(1151220,1))
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1151220,2))
			local g=Duel.SelectMatchingCard(tp,c1151220.ofilter2,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.ShuffleDeck(tp)
				Duel.MoveSequence(tc,0)
				Duel.ConfirmDecktop(tp,1)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g=Duel.SelectReleaseGroup(tp,c1151220.ofilter2x1,1,1,nil)
			if g:GetCount()>0 then
				if Duel.Release(g,REASON_EFFECT)~=0 and Duel.SelectMatchingCard(tp,c1151220.ofilter2x2,tp,LOCATION_GRAVE,0,1,1,nil) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	 
					local g2=Duel.SelectMatchingCard(tp,c1151220.ofilter2x2,tp,LOCATION_GRAVE,0,1,1,nil)   
					if g2:GetCount()>0 then
						Duel.SendtoHand(g2,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g2)
					end
				end
			end 
		end
	end
	if not Duel.IsExistingMatchingCard(c1151220.cfilter2,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckReleaseGroup(tp,c1151220.tfilter2x1,1,nil) and Duel.IsExistingMatchingCard(c1151220.cfilter2x2,tp,LOCATION_GRAVE,0,1,nil)) then
		local sel=Duel.SelectOption(tp,aux.Stringid(1151220,1))
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g=Duel.SelectReleaseGroup(tp,c1151220.ofilter2x1,1,1,nil)
			if g:GetCount()>0 then
				if Duel.Release(g,REASON_EFFECT)~=0 and Duel.SelectMatchingCard(tp,c1151220.ofilter2x2,tp,LOCATION_GRAVE,0,1,1,nil) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	 
					local g2=Duel.SelectMatchingCard(tp,c1151220.ofilter2x2,tp,LOCATION_GRAVE,0,1,1,nil)   
					if g2:GetCount()>0 then
						Duel.SendtoHand(g2,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g2)
					end
				end
			end 
		end
	end
end




