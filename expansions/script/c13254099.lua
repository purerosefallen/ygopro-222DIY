--元始·飞球之耀光
function c13254099.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254099,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13254099)
	e1:SetTarget(c13254099.target)
	e1:SetOperation(c13254099.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254099,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,13254099)
	e2:SetCost(c13254099.cost)
	e2:SetTarget(c13254099.sptarget)
	e2:SetOperation(c13254099.spoperation)
	c:RegisterEffect(e2)
	
end
function c13254099.thfilter(c,att,e,tp)
	return c:IsSetCard(0x3356) and c:IsAttribute(att) and c:IsAbleToHand()
end
function c13254099.filter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c13254099.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp)
end
function c13254099.chkfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c13254099.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c13254099.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c13254099.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c13254099.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function c13254099.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetAttribute()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c13254099.thfilter,tp,LOCATION_DECK,0,1,1,nil,att,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c13254099.cfilter(c)
	return c:IsSetCard(0x356) and c:IsDiscardable()
end
function c13254099.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c13254099.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c13254099.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c13254099.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD+LOCATION_REMOVED,1,nil) or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_EXTRA) end
	Duel.SetTargetPlayer(tp)
	Duel.SetChainLimit(aux.FALSE)
end
function c13254099.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_DECK)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.ShuffleHand(1-p)
	end
end
