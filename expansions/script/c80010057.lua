--666 平衡法师
function c80010057.initial_effect(c)
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80010057,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c80010057.lvtg)
	e1:SetOperation(c80010057.lvop)
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80010057,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,80010057)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c80010057.cost)
	e2:SetTarget(c80010057.thtg)
	e2:SetOperation(c80010057.thop)
	c:RegisterEffect(e2) 
end
function c80010057.filter(c)
	return c:IsFaceup() and c:GetLevel()==6
end
function c80010057.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80010057.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c80010057.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80010057.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(12)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c80010057.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetLevel()==6
end
function c80010057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80010057.thfilter,tp,LOCATION_DECK,0,6,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c80010057.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80010057.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=6 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,6,6,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c80010057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end