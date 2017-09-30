--奇迹糕点 后点心
function c12000009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12000009)
	e1:SetCost(c12000009.cost)
	e1:SetTarget(c12000009.target)
	e1:SetOperation(c12000009.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,12000109)
	e2:SetCost(c12000009.thcost)
	e2:SetTarget(c12000009.thtg)
	e2:SetOperation(c12000009.thop)
	c:RegisterEffect(e2)
end
function c12000009.cfilter(c)
	return c:IsSetCard(0xfbe) and c:IsAbleToGraveAsCost()
end
function c12000009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000009.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12000009.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,POS_FACEUP,REASON_COST)
end
function c12000009.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and c:IsFaceup()
end
function c12000009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c12000009.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c12000009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c12000009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c12000009.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c12000009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12000009.thfilter(c)
	return c:IsSetCard(0xfbe) and c:IsAbleToHand()
end
function c12000009.cfilter3(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c12000009.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetRace())
end
function c12000009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12000009.cfilter3,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c12000009.cfilter3,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetLabelObject(g:GetFirst())
end
function c12000009.thop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetAttribute()
	local race=e:GetLabelObject():GetRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000009.thfilter,tp,LOCATION_DECK,0,1,1,nil,att,race)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

