--秘谈·澄澈的空海
function c1111011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1111011.cost1)
	e1:SetTarget(c1111011.tg1)
	e1:SetOperation(c1111011.op1)
	c:RegisterEffect(e1)	
--  
end
--
function c1111011.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1111011.cfilter1(c)
	return c1111011.IsLd(c)
end
function c1111011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111011.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c1111011.cfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
--
function c1111011.tfilter1(c)
	return c:IsFacedown()
end
function c1111011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111011.tfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1111011.ofilter1(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c1111011.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1111011.tfilter1,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g2=g:FilterSelect(tp,c1111011.ofilter1,1,1,nil)
		if g2:GetCount()>0 then
			local tc2=g2:GetFirst()
			Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		end
	end
end
--