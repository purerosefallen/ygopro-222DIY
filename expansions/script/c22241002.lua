--Solid 零二三
function c22241002.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,222410021+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c22241002.cost)
	e2:SetTarget(c22241002.target)
	e2:SetOperation(c22241002.operation)
	c:RegisterEffect(e2)
	--Release-
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22241002,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,222410022)
	e2:SetCondition(c22241002.adcon)
	e2:SetTarget(c22241002.adtg)
	e2:SetOperation(c22241002.adop)
	c:RegisterEffect(e2)
end
c22241002.named_with_Solid=1
function c22241002.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22241002.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_COST)
	if c22241002.IsSolid(tc) then 
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c22241002.filter(c)
	return c:IsAbleToHand() and c22241002.IsSolid(c) and c:IsType(TYPE_SPELL)
end
function c22241002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22241002.filter,tp,LOCATION_DECK,0,2,nil) end
	if e:GetLabel()==1 then
		Duel.SetChainLimit(aux.FALSE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,2,tp,LOCATION_DECK)
end
function c22241002.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if not Duel.IsExistingMatchingCard(c22241002.filter,tp,LOCATION_DECK,0,2,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c22241002.filter,tp,LOCATION_DECK,0,2,2,nil)
	if g then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22241002.thfilter(c)
	return bit.band(c:GetReason(),REASON_RELEASE)~=0 and c22241002.IsSolid(c) and c:IsAbleToHand()
end
function c22241002.adcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return bit.band(e:GetHandler():GetReason(),REASON_RELEASE)~=0
end
function c22241002.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22241002.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c22241002.adop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c22241002.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) then return end
	local g=Duel.SelectMatchingCard(tp,c22241002.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end