--★時限ボーグ
function c114001313.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCountLimit(1,114001313+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c114001313.cost)
	e1:SetTarget(c114001313.target)
	e1:SetOperation(c114001313.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c114001313.handcon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c114001313.thcon)
	e3:SetTarget(c114001313.thtg)
	e3:SetOperation(c114001313.thop)
	c:RegisterEffect(e3)
end
function c114001313.cffilter(c)
	return c:IsSetCard(0x221) and not c:IsPublic()
end
function c114001313.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001313.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c114001313.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
--
function c114001313.filter(c)
	return c:IsDestructable() and c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c114001313.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c114001313.filter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c114001313.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c114001313.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==Duel.GetMatchingGroupCount(Card.IsPublic,tp,0,LOCATION_HAND,nil)
		and not Duel.IsExistingMatchingCard(c114001313.cfilter,tp,0,LOCATION_HAND,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
end
function c114001313.cfilter(c)
	return c:IsSetCard(0x221) and c:IsAbleToDeck()
end
function c114001313.activate(e,tp,eg,ep,ev,re,r,rp)
	--being negated
	if Duel.IsChainDisablable(0) then
		local cg=Duel.GetMatchingGroup(c114001313.cfilter,tp,0,LOCATION_HAND,nil)
		if cg:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(114001313,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local sg=cg:Select(1-tp,1,1,nil)
			Duel.ConfirmCards(tp,sg)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
			return
		end
	end
	--destroy
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
--
function c114001313.hdfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x221)
end
function c114001313.handcon(e)
	return not Duel.IsExistingMatchingCard(c114001313.hdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--
function c114001313.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and bit.band(r,REASON_EFFECT)~=0 and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c114001313.thfilter(c)
	return c:IsCode(114001313) and c:IsAbleToHand()
end
function c114001313.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114001313.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114001313.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,114001313) then
			local cg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
			Duel.ConfirmCards(1-tp,cg)
			Duel.ShuffleDeck(tp)
		end
	end
end