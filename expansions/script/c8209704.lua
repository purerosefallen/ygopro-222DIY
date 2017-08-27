--风暴元素
function c8209704.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1212),3,2)
	c:EnableReviveLimit()
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8209704,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,8209704)
	e2:SetCost(c8209704.cost)
	e2:SetTarget(c8209704.tdtg)
	e2:SetOperation(c8209704.tdop)
	c:RegisterEffect(e2)
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8209704,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,8209704)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c8209704.cost)
	e1:SetTarget(c8209704.target)
	e1:SetOperation(c8209704.operation)
	c:RegisterEffect(e1)
end
function c8209704.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8209704.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c8209704.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c8209704.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c8209704.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8209704.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c8209704.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,2,REASON_EFFECT)
	end
end
function c8209704.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1212) and c:IsAbleToHand()
end
function c8209704.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8209704.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8209704.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8209704.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end