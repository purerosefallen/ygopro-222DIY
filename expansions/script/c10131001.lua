--自由斗士·飞翔的科普
function c10131001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10131001+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10131001.ahop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131001,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10131001.descon)
	e2:SetTarget(c10131001.destg)
	e2:SetOperation(c10131001.desop)
	c:RegisterEffect(e2) 
end
function c10131001.cfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x5338)
end
function c10131001.descon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c10131001.cfilter,nil,tp)-tg:GetCount()>0
end
function c10131001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10131001.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10131001.ahfilter(c)
	return c:IsSetCard(0x5338) and c:IsAbleToHand() and not c:IsCode(10131001)
end
function c10131001.ahop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c10131001.ahfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10131001,0)) then
	   if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c10131001.ahfilter,tp,LOCATION_DECK,0,1,1,nil)
	   if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
	   end
	end
end