--神罚『年幼的恶魔之王』
function c1151202.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151202+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1151202.cost1)
	e1:SetOperation(c1151202.op1)
	c:RegisterEffect(e1)	
--  
end
--
function c1151202.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151202.named_with_Leisp=1
function c1151202.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151202.cfilter1(c)
	return (c1151202.IsLeisp(c) or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND))) and c:IsAbleToRemoveAsCost()
end
function c1151202.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151202.cfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1151202.cfilter1,tp,LOCATION_GRAVE,0,1,2,e:GetHandler())
	if g:GetCount()>0 then
		local rnum=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		e:SetLabel(rnum)
	end 
end
--
function c1151202.ofilter1(c)
	return (c1151202.IsLeisp(c) or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND))) and c:IsAbleToHand()
end
function c1151202.ofilter1x(c)
	return c:IsDestructable()
end
function c1151202.ofilter1x1(c)
	return c:IsAbleToDeck()
end
function c1151202.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==nil then return false end
	local rnum=e:GetLabel()
	if Duel.IsExistingMatchingCard(c1151202.ofilter1,tp,LOCATION_DECK,0,1,nil) and rnum>0 and Duel.SelectYesNo(tp,aux.Stringid(1151202,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1151202.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,tc)
				if tc:IsType(TYPE_MONSTER) and not c1151202.IsLeimi(tc) then
					local e1_1=Effect.CreateEffect(e:GetHandler())
					e1_1:SetType(EFFECT_TYPE_SINGLE)
					e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1_1:SetReset(RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1_1,true)
				end
			end
		end  
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and rnum>1 and Duel.SelectYesNo(tp,aux.Stringid(1151202,1)) then
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g2:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g3=g2:FilterSelect(tp,c1151202.ofilter1x,1,1,nil)
			if g3:GetCount()>0 then
				if Duel.Destroy(g3,REASON_EFFECT)~=0 then
					if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1151202.ofilter1x1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1151202,2)) then
						local g5=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
						local g4=Duel.SelectMatchingCard(tp,c1151202.tfilter1x1,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
						if g4:GetCount()>0 then
							Duel.SendtoDeck(g4,nil,0,REASON_EFFECT)
						end
					end
				end
			end
			Duel.ShuffleHand(1-tp)
		end
	end
end
