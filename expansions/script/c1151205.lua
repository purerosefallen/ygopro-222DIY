--神术『吸血鬼幻想』
function c1151205.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1151205.tg1)
	e1:SetOperation(c1151205.op1)
	c:RegisterEffect(e1)
--
end
--
function c1151205.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151205.named_with_Leisp=1
function c1151205.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
function c1151205.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
--
function c1151205.tfilter1_1(c)
	return c1151205.IsLeimi(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1151205.tfilter1_2(c)
	return (c1151205.IsLeisp(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand() and not c:IsCode(1151205)) or (c1151205.IsFulan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand())
end
function c1151205.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c1151205.tfilter1_1,tp,LOCATION_DECK,0,1,nil) and not Duel.IsExistingMatchingCard(c1151205.ofilter1_1,tp,LOCATION_ONFIELD,0,1,nil)) or Duel.IsExistingMatchingCard(c1151205.ofilter1_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1151205.ofilter1_1(c)
	return c1151205.IsLeimi(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1151205.ofilter1_2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:GetLevel()>0
end
function c1151205.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c1151205.ofilter1_1,tp,LOCATION_ONFIELD,0,1,nil) then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
		local g=Duel.GetMatchingGroup(c1151205.tfilter1_1,tp,LOCATION_DECK,0,nil)
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local seq=-1
		local tc=g:GetFirst()
		local spcard=nil
		while tc do
			if tc:GetSequence()>seq then 
				seq=tc:GetSequence()
				spcard=tc
			end
			tc=g:GetNext()
		end
		if seq==-1 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		Duel.ConfirmDecktop(tp,dcount-seq)
		if spcard:IsAbleToHand() then
			Duel.SendtoHand(spcard,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,spcard)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c1151205.ofilter1_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)	 
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.Hint(HINT_SELECTMSG,1-tp,567)
			local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
			local e1_3=Effect.CreateEffect(tc)
			e1_3:SetType(EFFECT_TYPE_SINGLE)
			e1_3:SetCode(EFFECT_CHANGE_LEVEL)
			e1_3:SetValue(lv)
			e1_3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_3)
			if Duel.IsExistingMatchingCard(c1151205.tfilter1_2,tp,LOCATION_DECK,0,1,nil) and tc:GetLevel()==lv and Duel.SelectYesNo(tp,aux.Stringid(1151205,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c1151205.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
