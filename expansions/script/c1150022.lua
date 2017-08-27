--高音合唱
function c1150022.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1150022.cost1)
	e1:SetTarget(c1150022.tg1)
	e1:SetOperation(c1150022.op1)
	c:RegisterEffect(e1)
--  
end
--
function c1150022.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone(e1)
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
--
function c1150022.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
--
function c1150022.ofilter1(c,e)
	local def=e:GetLabel()+1
	return c:IsFaceup() and c:GetDefense()<def and c:IsAbleToHand() and not c:IsType(TYPE_LINK)
end
function c1150022.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		local gn2=Group.CreateGroup()
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				if tc:IsType(TYPE_MONSTER) then
					gn2:AddCard(tc)
				end
				tc=g:GetNext()
			end
		end
		if gn2:GetCount()==2 then
			local gn=Group.CreateGroup()
			local tc=gn2:GetFirst()
			while tc do
				if tc:GetLevel()<5 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
					gn:AddCard(tc)
				end
				tc=gn2:GetNext()
			end
			if gn:GetCount()==2 then
				local tc=gn:GetFirst()
				local code1=tc:GetCode()
				tc=gn:GetNext()
				local code2=tc:GetCode()
				if code1~=code2 then
					local num=Duel.SpecialSummon(gn,0,tp,tp,false,false,POS_FACEUP)
					if num~=0 then
						local tc2=gn:GetFirst()
						while tc2 do
							local e1_1=Effect.CreateEffect(e:GetHandler())
							e1_1:SetType(EFFECT_TYPE_SINGLE)
							e1_1:SetCode(EFFECT_DISABLE)
							e1_1:SetReset(RESET_EVENT+0x1fe0000)
							tc2:RegisterEffect(e1_1,true)
							local e1_2=Effect.CreateEffect(e:GetHandler())
							e1_2:SetType(EFFECT_TYPE_SINGLE)
							e1_2:SetCode(EFFECT_DISABLE_EFFECT)
							e1_2:SetReset(RESET_EVENT+0x1fe0000)
							tc2:RegisterEffect(e1_2,true)
							tc2=gn:GetNext()
						end
					end
					if num==2 then
						local def=0
						local tc3=gn:GetFirst()
						while tc3 do
							def=def+tc3:GetDefense()
							tc3=gn:GetNext()
						end
						e:SetLabel(def)
						local g3=Duel.GetMatchingGroup(c1150022.ofilter1,tp,0,LOCATION_MZONE,nil,e)
						if g3:GetCount()>0 then
							Duel.SendtoHand(g3,nil,REASON_EFFECT)
						end
					end
				else
					Duel.ShuffleDeck(tp)
				end
			else
				Duel.ShuffleDeck(tp)
			end
		else
			Duel.ShuffleDeck(tp)
		end
	end
end






