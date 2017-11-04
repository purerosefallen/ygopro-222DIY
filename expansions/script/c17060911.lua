--あやと
function c17060911.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060911,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060911)
	e1:SetTarget(c17060911.thtg)
	e1:SetOperation(c17060911.thop)
	c:RegisterEffect(e1)
end
c17060911.is_named_with_Waves_Type=1
function c17060911.IsWaves_Type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Waves_Type
end
function c17060911.thfilter(c)
	return c:IsFaceup() and c17060911.IsWaves_Type(c) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c17060911.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17060911.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c17060911.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17060911.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end