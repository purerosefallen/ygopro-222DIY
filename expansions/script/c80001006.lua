--冰之羽翼 雪暴羽翼鸟
function c80001006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80001006.matfil,4,2)
	c:EnableReviveLimit()   
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80001006,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,80001007)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c80001006.thcost)
	e1:SetCondition(c80001006.discon)
	e1:SetTarget(c80001006.distg)
	e1:SetOperation(c80001006.disop)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001006,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetCondition(c80001006.spcon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,80001006)
	e3:SetCost(c80001006.thcost)
	e3:SetTarget(c80001006.thtg)
	e3:SetOperation(c80001006.thop)
	c:RegisterEffect(e3)
end
function c80001006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalRace()==RACE_WINDBEAST 
end
function c80001006.matfil(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80001006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80001006.thfilter(c)
	return c:GetLevel()==4 and c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c80001006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001006.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80001006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80001006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80001006.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and tp==Duel.GetTurnPlayer() and Duel.IsChainNegatable(ev)
end
function c80001006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80001006.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end