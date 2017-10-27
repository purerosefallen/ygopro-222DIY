--冥符『红色的冥界』
function c1151203.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151203+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1151203.cost1)
	e1:SetTarget(c1151203.tg1)
	e1:SetOperation(c1151203.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1151203.cost2)
	e2:SetTarget(c1151203.tg2)
	e2:SetOperation(c1151203.op2)
	c:RegisterEffect(e2)
--
	Duel.AddCustomActivityCounter(1151203,ACTIVITY_SPSUMMON,c1151203.counterfilter)  
end
--
function c1151203.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151203.named_with_Leisp=1
function c1151203.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151203.counterfilter(c)
	return c:IsRace(RACE_FIEND)
end
--
function c1151203.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToGraveAsCost()
end
function c1151203.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1151203,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c1151203.cfilter1,tp,LOCATION_DECK,0,1,nil) end
--
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1151203.splimit1_1)
	Duel.RegisterEffect(e1_1,tp)
--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1151203.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c1151203.splimit1_1(e,c)
	return not c:IsRace(RACE_FIEND)
end
--
function c1151203.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151996,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1151203.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151996,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,1151996)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c1151203.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1151203.tfilter2(c,e,tp)
	return ((c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER)) or c1151203.IsLeisp(c)) and c:IsAbleToDeck()
end
function c1151203.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151203.tfilter2,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,0)
end
--
function c1151203.ofilter2(c)
	return c:IsRace(RACE_FIEND)
end
function c1151203.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1151203.tfilter2,tp,LOCATION_REMOVED,0,1,3,e:GetHandler())
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(tp)
			if Duel.CheckReleaseGroup(tp,c1151203.ofilter2,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(1151203,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local g2=Duel.SelectReleaseGroup(tp,c1151203.ofilter2,1,1,nil)
				if g2:GetCount()>0 then
					if Duel.Release(g2,REASON_EFFECT)~=0 then
						Duel.Draw(tp,1,REASON_EFFECT)
					end
				end
			end
		end
	end
end
--
