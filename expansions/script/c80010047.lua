--222 整合
function c80010047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80010047+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80010047.target)
	e1:SetOperation(c80010047.activate)
	c:RegisterEffect(e1)
end
function c80010047.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c80010047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c80010047.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c80010047.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c80010047.filter,tp,LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c80010047.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function c80010047.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c80010047.filter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c80010047.filter,tp,LOCATION_ONFIELD,0,nil)
	local g3=Duel.GetMatchingGroup(c80010047.filter,tp,LOCATION_GRAVE,0,nil)
	local g4=Duel.GetMatchingGroup(c80010047.filter,tp,LOCATION_REMOVED,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:RandomSelect(tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg3=g3:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg4=g4:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		sg1:Merge(sg4)
		Duel.HintSelection(sg1)
		Duel.SendtoDeck(sg1,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
