--时空枢纽
function c13255217.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13255217,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c13255217.tdtg)
	e2:SetOperation(c13255217.tdop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13255217,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetCountLimit(1,13255217)
	e3:SetTarget(c13255217.rmtg)
	e3:SetOperation(c13255217.rmop)
	c:RegisterEffect(e3)
	--destroy
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(13255217,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetTarget(c13255217.sptg)
	e4:SetOperation(c13255217.spop)
	c:RegisterEffect(e4)
	--recover
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(13255217,4))
	e5:SetTarget(c13255217.rmtg2)
	e5:SetOperation(c13255217.rmop2)
	c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13255217,5))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetTarget(c13255217.rmtg3)
	e6:SetOperation(c13255217.rmop3)
	c:RegisterEffect(e6)
	
end
function c13255217.thfilter(c)
	return c:IsCode(13255200) and c:IsAbleToHand()
end
function c13255217.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c13255217.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=1 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==1 then
		local g=Duel.GetMatchingGroup(c13255217.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13255217,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13255217.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c13255217.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c13255217.rmfilter(c)
	return c:IsLevelBelow(1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c13255217.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13255217.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c13255217.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c13255217.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c13255217.spfilter(c,e,tp)
	return c:IsLevelBelow(1) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13255217.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c13255217.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c13255217.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13255217.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c13255217.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c13255217.rmop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c13255217.rmtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,PLAYER_ALL,LOCATION_DECK)
end
function c13255217.rmop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetDecktopGroup(tp,5)
	local g2=Duel.GetDecktopGroup(1-tp,5)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
