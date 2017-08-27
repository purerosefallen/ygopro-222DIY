--夢を拾う少女
function c114000581.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114000581,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c114000581.target)
	e1:SetOperation(c114000581.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(114000581,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c114000581.target2)
	e2:SetOperation(c114000581.activate2)
	c:RegisterEffect(e2)
end
function c114000581.filter1(c)
	return c:IsAbleToDeck()
	and ( ( c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) ) or c:IsType(TYPE_FIELD) )
	and ( c:IsLocation(LOCATION_GRAVE) or ( c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() ) )
end
function c114000581.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c114000581.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c114000581.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,99,nil)
	local ct=g1:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c114000581.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		local sg=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if sg>0 then
			Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c114000581.filter2(c)
	return c:IsAbleToDeck()
	and c:IsFacedown()
end
function c114000581.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c114000581.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c114000581.filter2,tp,LOCATION_REMOVED,0,nil)
	local ct=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c114000581.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c114000581.filter2,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		local sg=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if sg>0 then
			Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end