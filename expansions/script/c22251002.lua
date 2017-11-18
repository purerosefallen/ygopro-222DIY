--似叶般飘落
function c22251002.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22251002,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22251002+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22251002.operation)
	c:RegisterEffect(e1)
	--laipigou
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22251002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22251002.cost)
	e2:SetCondition(c22251002.con)
	e2:SetTarget(c22251002.tg)
	e2:SetOperation(c22251002.op)
	c:RegisterEffect(e2)
end
c22251002.named_with_Riviera=1
function c22251002.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22251002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c22251002.thcon)
	e1:SetOperation(c22251002.thop)
	e1:SetCountLimit(2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22251002.thcfilter(c,sp)
	return c22251002.IsRiviera(c) and c:IsType(TYPE_MONSTER)
end
function c22251002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22251002.thcfilter,1,nil)
end
function c22251002.thfilter(c,sp)
	return c22251002.IsRiviera(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22251002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22251002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,0)
end
function c22251002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22251002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22251002.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c22251002.costfilter(c)
	return c22251002.IsRiviera(c) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c22251002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22251002.costfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 end
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		if Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(c22251002.retop)
			Duel.RegisterEffect(e1,tp)
		end
	tc=g:GetNext()
	end
end
function c22251002.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22251002.tdfilter(c)
	return c:IsCode(22251002) and c:IsAbleToDeck()
end
function c22251002.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c22251002.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
end
