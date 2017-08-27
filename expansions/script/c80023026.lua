--番长组合技-A
function c80023026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80023026+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80023026.target)
	e1:SetOperation(c80023026.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80023026,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c80023026.thcost)
	e2:SetLabel(5)
	e2:SetCondition(c80023026.effcon)
	e2:SetTarget(c80023026.destg)
	e2:SetOperation(c80023026.desop)
	c:RegisterEffect(e2)
end
function c80023026.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa2d6) and c:IsType(TYPE_RITUAL)
end
function c80023026.effcon(e)
	return Duel.GetMatchingGroup(c80023026.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c80023026.filter(c)
	return c:IsCode(80023022) and c:IsAbleToHand()
end
function c80023026.filter1(c)
	return c:IsSetCard(0xa2d6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c80023026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80023026.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c80023026.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80023026.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80023026.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c80023026.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and g1:GetCount()>0 then
	g:Merge(g1)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80023026.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c80023026.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c80023026.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end