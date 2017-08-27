--冰龙剑
function c10173009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10173009.spcon)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173009,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10173009)
	e2:SetTarget(c10173009.tdtg)
	e2:SetOperation(c10173009.tdop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173009,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10173109)
	e3:SetCost(c10173009.descost)
	e3:SetTarget(c10173009.destg)
	e3:SetOperation(c10173009.desop)
	c:RegisterEffect(e3)
end
function c10173009.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10173009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		   e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10173009.rfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10173009.rfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,g:GetCount(),0,LOCATION_ONFIELD)
end
function c10173009.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c10173009.rfilter(c,e,tp)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and Duel.IsExistingMatchingCard(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e) 
end
function c10173009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c10173009.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10173009.eqfilter(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsAbleToHand()
end
function c10173009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
	   Duel.ShuffleDeck(tp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c10173009.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.SendtoHand(g,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,g)
	   end
	end
end
function c10173009.spfilter(c)
	return c:IsFaceup() and c:IsCode(10113059)
end
function c10173009.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10173009.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end