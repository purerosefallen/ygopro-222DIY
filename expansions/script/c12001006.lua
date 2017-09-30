--六曜的卜时
function c12001006.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--announce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12001006,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12001006.target)
	e2:SetOperation(c12001006.operation)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c12001006.actg)
	e4:SetOperation(c12001006.acop)
	c:RegisterEffect(e4)
end
function c12001006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c12001006.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xfb0) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleDeck(nil)
	end
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
	if tg:GetCount()>1 and tg:IsExists(Card.IsSetCard,1,nil,0xfb0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg1=tg:Select(tp,Card.IsSetCard,1,1,nil,0xfb0)
			Duel.ConfirmCards(1-tp,sg1)
			Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)
	  else
			local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.ConfirmCards(1-tp,hg)
			local ct=Duel.SendtoDeck(hg,nil,0,REASON_EFFECT)
			Duel.SortDecktop(tp,tp,ct)
	   end
end
function c12001006.acfilter(c)
	return c:IsSetCard(0xfb0) and c:IsAbleToDeck()
end
function c12001006.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12001006.acfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12001006.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SelectTarget(tp,c12001006.acfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c12001006.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
end