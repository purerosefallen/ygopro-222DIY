--星野夢美
function c18706025.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17393207,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18706025)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c18706025.cost)
	e1:SetTarget(c18706025.target)
	e1:SetOperation(c18706025.operation)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(68597372,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,18706025)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c18706025.costa)
	e2:SetTarget(c18706025.target)
	e2:SetOperation(c18706025.operation)
	c:RegisterEffect(e2)
end
function c18706025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() or c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c18706025.costa(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c18706025.filter(c)
	return c:IsSetCard(0x1330) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c18706025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c18706025.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18706025.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18706025.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end