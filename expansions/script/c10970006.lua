--纸上台本 「芙蓉石的长年隔绝」
function c10970006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,10970001+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10970006.atg)
	c:RegisterEffect(e1)  
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10970006,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetTarget(c10970006.thtg)
    e2:SetOperation(c10970006.tgop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10970006,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCondition(c10970006.condition)
	e3:SetCost(c10970006.descost)
	e3:SetTarget(c10970006.destg)
	e3:SetOperation(c10970006.desop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10970006.condition2)
	e4:SetOperation(c10970006.desop2)
	c:RegisterEffect(e4)	
end
function c10970006.atg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end 
   if c10970006.descost(e,tp,eg,ep,ev,re,r,rp,0) and c10970006.condition(e,tp,eg,ep,ev,re,r,rp,0) and c10970006.destg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		c10970006.descost(e,tp,eg,ep,ev,re,r,rp,1)
		c10970006.destg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c10970006.desop)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10970006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1233)
end
function c10970006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10970006.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c10970006.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10970006.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,10970008)
end
function c10970006.cfilter(c)
	return c:IsCode(10970001) and c:IsAbleToGraveAsCost()
end
function c10970006.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10970006.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10970006.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10970006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.GetFlagEffect(tp,10970006)==0 and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.RegisterFlagEffect(tp,10970006,RESET_PHASE+PHASE_END,0,1)
end
function c10970006.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10970006.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10970006.thfilter2(c)
    return c:IsCode(10970001) and c:IsAbleToHand()
end
function c10970006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10970006.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10970006.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c10970006.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

