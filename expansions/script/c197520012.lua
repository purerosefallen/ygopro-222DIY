--蹦跳吧 少年
function c197520012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+0x1c0,TIMING_STANDBY_PHASE+0x1c0)
	e1:SetTarget(c197520012.target)
	e1:SetOperation(c197520012.activate)
	c:RegisterEffect(e1) 
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0) 
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(197520012,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(aux.exccon)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetTarget(c197520012.tgtg)
	e2:SetOperation(c197520012.tgop)
	c:RegisterEffect(e2)  
end
function c197520012.filter(c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c197520012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c197520012.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c197520012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c197520012.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c197520012.tgfilter(c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c197520012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(c197520012.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c197520012.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c197520012.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end