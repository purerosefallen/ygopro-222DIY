--栀子色之希
function c1150028.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150028+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1150028.con1)
	e1:SetTarget(c1150028.tg1)
	e1:SetOperation(c1150028.op1)
	c:RegisterEffect(e1)  
--	
end
--
function c1150028.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler())
end
--
function c1150028.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
	local sg=Duel.GetMatchingGroup(aux.TURE,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()>2 then
	   Duel.SetChainLimit(c1150028.limit1)
	end
end
--
function c1150028.limit1(e,ep,tp)
	return tp==ep
end
--
function c1150028.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 then
		Duel.ConfirmDecktop(tp,3)		
		local g=Duel.GetDecktopGroup(tp,3)
		local gn=Group.CreateGroup()  
		local gn5=Group.CreateGroup()
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
					gn:AddCard(tc)
				end
				if tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP) then
					gn5:AddCard(tc)
				end
				tc=gn:GetNext()
			end
		end
		if gn:GetCount()>0 and Duel.GetMZoneCount(tp)>0 then
			local ft=Duel.GetMZoneCount(tp)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then 
				ft=1 
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g3=gn:Select(tp,ft,ft,nil)
			local tc3=g3:GetFirst()
			while tc3 do
				Duel.SpecialSummonStep(tc3,0,tp,tp,false,false,POS_FACEUP)
				tc3=g3:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
		Duel.ConfirmDecktop(1-tp,3)		
		local g2=Duel.GetDecktopGroup(1-tp,3)
		local gn2=Group.CreateGroup()		
		if g2:GetCount()>0 then
			local tc2=g2:GetFirst()
			while tc2 do
				if tc2:IsCanBeSpecialSummoned(e,0,tp,false,false) then
					gn2:AddCard(tc2)
				end
				tc2=gn2:GetNext()
			end
		end 
		if gn2:GetCount()>0 and Duel.GetMZoneCount(1-tp)>0 then
			local ft2=Duel.GetMZoneCount(1-tp)
			if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then 
				ft2=1 
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g4=gn2:Select(tp,ft2,ft2,nil)
			local tc4=g4:GetFirst()
			while tc4 do
				Duel.SpecialSummonStep(tc4,0,tp,tp,false,false,POS_FACEUP)
				tc4=g4:GetNext()
			end
			Duel.SpecialSummonComplete()
		end	
		if gn5:GetCount()>0 then
			local num=gn5:GetCount()
			if Duel.Remove(gn5,POS_FACEUP,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				Duel.Draw(tp,num,REASON_EFFECT)
			end
		end
	end
end
