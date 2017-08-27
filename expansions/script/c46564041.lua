--季 转 轮 回 之 曲
function c46564041.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46564041,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c46564041.cost)
	e2:SetTarget(c46564041.tdtg)
	e2:SetOperation(c46564041.tdop)
	c:RegisterEffect(e2)
	--Destroy and Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(46564041,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c46564041.destg)
	e3:SetOperation(c46564041.desop)
	c:RegisterEffect(e3)
end
function c46564041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(46564041)==0 end
	e:GetHandler():RegisterFlagEffect(46564041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c46564041.tdfilter(c)
	return (c:IsSetCard(0x65a) or c:IsSetCard(0x65b) or c:IsSetCard(0x5334) or c:IsSetCard(0xc330)) and c:IsAbleToDeck() and c:IsFaceup()
end
function c46564041.tgfilter(c)
	return c:IsLevelAbove(4) and c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c46564041.thfilter(c)
	return (c:IsCode(46564042) or c:IsCode(46564043)) and c:IsAbleToHand()
end
function c46564041.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c46564041.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c46564041.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c46564041.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c46564041.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 then
		if not Duel.IsExistingMatchingCard(c46564041.tgfilter,tp,LOCATION_DECK,0,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(46564041,2)) then return end
		local g=Duel.SelectMatchingCard(tp,c46564041.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c46564041.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c46564041.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c46564041.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.IsExistingMatchingCard(c46564041.thfilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c46564041.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end
	end
end

