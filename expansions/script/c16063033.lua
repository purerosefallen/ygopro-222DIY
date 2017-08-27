--xixi
function c16063033.initial_effect(c)
	--atcivate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16063033+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c16063033.target)
	e1:SetOperation(c16063033.activate)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16063033,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c16063033.tdcon)
	e2:SetTarget(c16063033.tdtg)
	e2:SetOperation(c16063033.tdop)
	c:RegisterEffect(e2)
end
function c16063033.desfilter(c,e,tp)
	return c:IsSetCard(0x5c5) and c:IsFaceup() and c:IsDestructable()
end
function c16063033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c16063033.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16063033.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16063033.desfilter,tp,LOCATION_ONFIELD,0,1,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16063033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c16063033.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c16063033.tdfilter(c)
	return c:IsSetCard(0x5c5) and c:IsAbleToDeck()
end
function c16063033.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16063033.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end
function c16063033.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c16063033.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()~=2 then return end
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end