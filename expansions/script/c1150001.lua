--蓝色星空
function c1150001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(1150001,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1150001)
	e2:SetLabelObject(e1)
	e2:SetTarget(c1150001.tg2)
	e2:SetOperation(c1150001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1150001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if chk==0 then return tc and tc2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1150001,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(1150001,1))
	e:GetLabelObject():SetLabel(Duel.SelectOption(1-tp,70,71,72))
end
--
function c1150001.ofilter2(c)
	return c:IsAbleToDeck()
end
function c1150001.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
		local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
		if e:GetHandler():IsOnField() and tc and tc2 then
			local t=0
			local t2=0
			local opt=e:GetLabel()
			local opt2=e:GetLabelObject():GetLabel()   
			if opt==0 then t=TYPE_MONSTER 
			else 
				if opt==1 then t=TYPE_SPELL 
				else t=TYPE_TRAP 
				end
			end
			if opt2==0 then t2=TYPE_MONSTER 
			else 
				if opt2==1 then t2=TYPE_SPELL 
				else t2=TYPE_TRAP 
				end
			end
			Duel.ConfirmDecktop(tp,1)
			if tc:IsType(t) and tc:IsAbleToHand() then
				Duel.SendtoHand(tc,tp,REASON_EFFECT) 
			end 
			if not tc:IsType(t) and Duel.IsExistingMatchingCard(c1150001.ofilter2,tp,LOCATION_HAND,0,1,nil) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(1150001,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,c1150001.ofilter2,tp,LOCATION_HAND,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.DisableShuffleCheck()
					if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
					end
				end
			end
			Duel.ConfirmDecktop(1-tp,1)
			if tc2:IsType(t2) and tc2:IsAbleToHand() then
				Duel.SendtoHand(tc2,1-tp,REASON_EFFECT)
			end
			if not tc2:IsType(t2) and Duel.IsExistingMatchingCard(c1150001.ofilter2,tp,0,LOCATION_HAND,1,nil) and tc2:IsAbleToHand() and Duel.SelectYesNo(1-tp,aux.Stringid(1150001,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g2=Duel.SelectMatchingCard(1-tp,c1150001.ofilter2,tp,0,LOCATION_HAND,1,1,nil)
				if g2:GetCount()>0 then
					Duel.DisableShuffleCheck()
					if Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)~=0 then
						Duel.SendtoHand(tc2,nil,REASON_EFFECT)
					end
				end
			end
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
			local g3=Duel.GetDecktopGroup(tp,2)
			if g3:GetCount()>0 then
				Duel.DisableShuffleCheck()
				Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
			end
			local g4=Duel.GetDecktopGroup(1-tp,2)
			if g4:GetCount()>0 then
				Duel.DisableShuffleCheck()  
				Duel.Remove(g4,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end








