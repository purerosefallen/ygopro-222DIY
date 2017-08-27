--季风的神殿
function c10119010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--name
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(10119010,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10119010)
	e2:SetTarget(c10119010.tgtg)
	e2:SetOperation(c10119010.tgop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(10119010,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c10119010.thcost)
	e3:SetCountLimit(1,10119110)
	e3:SetTarget(c10119010.thtg)
	e3:SetOperation(c10119010.thop)
	c:RegisterEffect(e3)
end
function c10119010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10119010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10119010.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10119010.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10119010.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10119010.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c10119010.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode()) 
	if tg:GetCount()>0 then
	   Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	end
end
function c10119010.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x6331) and Duel.IsExistingMatchingCard(c10119010.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c10119010.thfilter2(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x6331) and c:IsType(TYPE_MONSTER) and not c:IsCode(code)
end
function c10119010.tgfilter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c10119010.tgfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c10119010.tgfilter2(c,code)
	return c:IsSetCard(0x6331) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsCode(code)
end
function c10119010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10119010.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10119010.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10119010.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10119010.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c10119010.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 and tg:GetFirst():IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tg:GetFirst():GetOriginalCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end