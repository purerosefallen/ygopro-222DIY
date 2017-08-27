--传颂篇章 双皇激斗
function c16063010.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c16063010.tg)
	e1:SetOperation(c16063010.op)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16063010,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c16063010.thcon)
	e2:SetTarget(c16063010.thtg)
	e2:SetOperation(c16063010.thop)
	c:RegisterEffect(e2)
end
function c16063010.sfilter(c)
	return  c:GetCode()==16063010  and c:IsSSetable()
end
function c16063010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(c16063010.sfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c16063010.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local setg=Duel.SelectMatchingCard(tp,c16063010.sfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
			if setg:GetCount()>0 then
			Duel.SSet(tp,setg)
			Duel.ConfirmCards(1-tp,setg)
end
end
function c16063010.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c16063010.thfilter(c)
	return c:IsSetCard(0x5c5) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToHand()
end
function c16063010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16063010.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c16063010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16063010.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end