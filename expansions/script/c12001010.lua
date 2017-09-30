--六曜的先胜
function c12001010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12001010+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12001010.target)
	e1:SetOperation(c12001010.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12001010,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12001105)
	e2:SetCondition(c12001010.drcon)
	e2:SetTarget(c12001010.drtg)
	e2:SetOperation(c12001010.drop)
	c:RegisterEffect(e2)
end
function c12001010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,2)
end
function c12001010.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()>1 and g:IsExists(Card.IsSetCard,1,nil,0xfb0) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg1=g:FilterSelect(p,Card.IsSetCard,1,1,nil,0xfb0)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg2=g:Select(p,1,1,sg1:GetFirst())
			sg1:Merge(sg2)
			Duel.ConfirmCards(1-p,sg1)
			Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)
			Duel.SortDecktop(p,p,2)
		else
			local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			Duel.ConfirmCards(1-p,hg)
			local ct=Duel.SendtoDeck(hg,nil,0,REASON_EFFECT)
			Duel.SortDecktop(p,p,ct)
		end
	end
end
function c12001010.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
function c12001010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c12001010.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(p,aux.TRUE,p,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end