--心之斩
function c80060024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80060024.target)
	e1:SetOperation(c80060024.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c80060024.condition)
	e2:SetCost(c80060024.cost)
	e2:SetTarget(c80060024.target)
	e2:SetOperation(c80060024.activate)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c80060024.thcost)
	e3:SetTarget(c80060024.thtg)
	e3:SetOperation(c80060024.thop)
	c:RegisterEffect(e3)
end
function c80060024.filter(c)
	return c:IsFaceup()
end
function c80060024.cfilter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsSetCard(0x92d7)
end
function c80060024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c80060024.cfilter,tp,LOCATION_MZONE,0,nil)
		e:SetLabel(ct)
		return Duel.IsExistingMatchingCard(c80060024.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,c)
	end
	local ct=e:GetLabel()
	local sg=Duel.GetMatchingGroup(c80060024.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,ct,0,0)
end
function c80060024.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c80060024.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c80060024.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,0,ct,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
end
function c80060024.filter1(c)
	return c:IsFaceup() and c:IsCode(80060000)
end
function c80060024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80060024.filter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) and Duel.GetTurnPlayer()~=tp
end
function c80060024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80060024.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function c80060024.thfilter(c)
	return c:IsCode(80060010) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80060024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80060024.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c80060024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80060024.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end