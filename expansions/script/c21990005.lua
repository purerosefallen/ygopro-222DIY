--奇迹 新星璀璨之夜
function c21990005.initial_effect(c)
	--copy spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21990005)
	e1:SetCondition(c21990005.condition)
	e1:SetCost(c21990005.cost)
	e1:SetTarget(c21990005.target)
	e1:SetOperation(c21990005.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21990005,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,21990005)
	e2:SetCondition(c21990005.descon)
	e2:SetTarget(c21990005.shtg)
	e2:SetOperation(c21990005.shop)
	c:RegisterEffect(e2)
end
function c21990005.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c21990005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21990005.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21990005.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	local rtc=g:GetFirst()
	Duel.SendtoGrave(rtc,REASON_COST)
	e:SetLabelObject(rtc)
end
function c21990005.cfilter(c)
	return c:IsSetCard(0xa219) and c:CheckActivateEffect(false,true,false)~=nil and c:IsAbleToGraveAsCost()
end
function c21990005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local rtc=e:GetLabelObject()
	local te=rtc:CheckActivateEffect(true,true,false)
	Duel.ClearTargetCard()
	rtc:CreateEffectRelation(e)
	e:SetLabelObject(te)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not cg then return end
	local tc=cg:GetFirst()
	while tc do
		tc:CreateEffectRelation(te)
		tc=cg:GetNext()
	end
end
function c21990005.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		local op=te:GetOperation()
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not cg then return end
		local tc=cg:GetFirst()
		while tc do
			tc:ReleaseEffectRelation(te)
			tc=cg:GetNext()
		end
	end
end
function c21990005.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActiveType(TYPE_SPELL)
end
function c21990005.filter(c)
	return c:IsSetCard(0x9219) and c:IsAbleToHand()
end
function c21990005.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21990005.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21990005.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21990005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end