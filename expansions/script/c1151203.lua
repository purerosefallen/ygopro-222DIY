--冥符『红色的冥界』
function c1151203.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1151203.cost1)
	e1:SetTarget(c1151203.tg1)
	e1:SetOperation(c1151203.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1151203.cost2)
	e2:SetTarget(c1151203.tg2)
	e2:SetOperation(c1151203.op2)
	c:RegisterEffect(e2)
--
end
--
function c1151203.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151203.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151203.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:GetAttack()==1800 and c:IsAbleToGraveAsCost()
end
function c1151203.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151203.cfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1151203.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--
function c1151203.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151990,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1151203.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151990,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,1151990)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	e:GetHandler():CancelToGrave()
end
--
function c1151203.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1151203.tfilter2(c)
	return c:IsAbleToDeck() and not c:IsCode(1151203)
end
function c1151203.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151203.tfilter2,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
--
function c1151203.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1151203.tfilter2,tp,LOCATION_REMOVED,0,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,c1151203.tfilter2,tp,LOCATION_REMOVED,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			local tg=g:RandomSelect(tp,1,1,nil)
			local tc=tg:GetFirst()
			g:RemoveCard(tc)
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end

