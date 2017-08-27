--早安！
function c1150011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1150011.cost1)
	e1:SetTarget(c1150011.tg1)
	e1:SetOperation(c1150011.op1)
	c:RegisterEffect(e1)
--	
end
--
function c1150011.cfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c1150011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetMatchingGroupCount(c1150011.cfilter1,tp,LOCATION_HAND,0,nil)==0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1150011.tfilter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:GetLevel()<5
end
function c1150011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>7 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
--
function c1150011.ofilter1(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<5 and c:IsAbleToHand()
end
function c1150011.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>7 then
		Duel.ConfirmDecktop(tp,8)
		local g=Duel.GetDecktopGroup(tp,8)
		if g:GetCount()>0 then
			if g:IsExists(c1150011.ofilter1,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c1150011.ofilter1,1,1,nil)
				if sg:GetCount()>0 then
					local tc=sg:GetFirst()
					if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
						Duel.ConfirmCards(1-tp,tc)
						Duel.BreakEffect()
						local e1_1=Effect.CreateEffect(e:GetHandler())
						e1_1:SetType(EFFECT_TYPE_FIELD)
						e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
						e1_1:SetCode(EFFECT_CANNOT_ACTIVATE)
						e1_1:SetTargetRange(1,0)
						e1_1:SetValue(c1150011.limit1_1)
						e1_1:SetLabel(tc:GetOriginalCode())
						e1_1:SetReset(RESET_PHASE+PHASE_END,2)
						Duel.RegisterEffect(e1_1,tp)
						local e1_2=Effect.CreateEffect(e:GetHandler())
						e1_2:SetType(EFFECT_TYPE_FIELD)
						e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
						e1_2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
						e1_2:SetTargetRange(1,0)
						e1_2:SetTarget(c1150011.limit1_2)
						e1_2:SetLabel(tc:GetCode())
						e1_2:SetReset(RESET_PHASE+PHASE_END,2)
						Duel.RegisterEffect(e1_2,tp)
						local e1_3=e1_2:Clone()
						e1_3:SetCode(EFFECT_CANNOT_SUMMON)			   
						Duel.RegisterEffect(e1_3,tp)
					end
				else
					Duel.ShuffleDeck(tp)
				end
			end
		end
	end
end
--
function c1150011.limit1_1(e,re,tp)
	return re:GetHandler():GetOriginalCode()==e:GetLabel()
end
--
function c1150011.limit1_2(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(e:GetLabel())
end
--
