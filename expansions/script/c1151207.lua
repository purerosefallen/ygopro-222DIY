--红符「绯红之主」
function c1151207.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151207+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1151207.cost1)
	e1:SetTarget(c1151207.tg1)
	e1:SetOperation(c1151207.op1)
	c:RegisterEffect(e1)
--
	Duel.AddCustomActivityCounter(1151207,ACTIVITY_SPSUMMON,c1151207.counterfilter) 
end
--
function c1151207.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151207.named_with_Leisp=1
function c1151207.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151207.counterfilter(c)
	return c:IsRace(RACE_FIEND)
end
--
function c1151207.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1151207,tp,ACTIVITY_SPSUMMON)==0 end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1151207.limit1_1)
	Duel.RegisterEffect(e1_1,tp)
end
function c1151207.limit1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_FIEND)
end
--
function c1151207.tfilter1_1(c,e,tp)
	return c:IsType(TYPE_TUNER) and c1151207.IsLeimi(c) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c1151207.tfilter1_2(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1151207.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then  
		local g1=Duel.GetMatchingGroup(c1151207.tfilter1_1,tp,LOCATION_DECK,0,nil,e,tp)
		local prepare=0
		if g1:GetCount()>0 then
			local tc1=g1:GetFirst()
			while tc1 do
				local g2=Duel.GetMatchingGroup(c1151207.tfilter1_2,tp,LOCATION_DECK,0,tc1,e,tp) 
				if g2:GetCount()>0 then
					prepare=1
					break
				end
				tc1=g1:GetNext()
			end
		end
		if prepare==1 then
			return Duel.GetMZoneCount(tp)>1  and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1
		else
			return false 
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
--
function c1151207.ofilter1(c,mg,e,tp)
	if not c:IsCode(1151101) then return false end
	if c:IsType(TYPE_SYNCHRO) then
		return c:IsSynchroSummonable(nil,mg)
	else
		return false
	end
end
function c1151207.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<2 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local gall=Group.CreateGroup()
	local real=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c1151207.tfilter1_1,tp,LOCATION_DECK,0,nil,e,tp)
	if g1:GetCount()>0 then
		local tc1=g1:GetFirst()
		while tc1 do
			local g2=Duel.GetMatchingGroup(c1151207.tfilter1_2,tp,LOCATION_DECK,0,tc1,e,tp) 
			if g2:GetCount()>0 then
				gall:AddCard(tc1)
			end
			tc1=g1:GetNext()
		end
	end
	if gall:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g3=gall:Select(tp,1,1,nil) 
		if g3:GetCount()>0 then  
			local tc3=g3:GetFirst()
			real:AddCard(tc3)
			local g4=Duel.GetMatchingGroup(c1151207.tfilter1_2,tp,LOCATION_DECK,0,tc3,e,tp)
			if g4:GetCount()>0 then
				local g5=Duel.SelectMatchingCard(tp,c1151207.tfilter1_2,tp,LOCATION_DECK,0,1,1,tc3,e,tp)
				if g5:GetCount()>0 then
					local tc5=g5:GetFirst()
					real:AddCard(tc5)
					if Duel.SpecialSummon(real,0,tp,tp,false,false,POS_FACEUP)==2 then
						Duel.BreakEffect()
						local g6=Duel.GetMatchingGroup(c1151207.ofilter1,tp,LOCATION_EXTRA,0,nil,real,e,tp)
						if not g6 or g6:GetCount()==0 then 
							Duel.SendtoGrave(real,REASON_EFFECT)
							return 
						end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local g7=g6:Select(tp,1,1,nil)
						local tc7=g7:GetFirst()
						if tc7:IsType(TYPE_SYNCHRO) then
							Duel.SynchroSummon(tp,tc7,nil,real)
						end
					end
				end
			end
		end
	end
end
