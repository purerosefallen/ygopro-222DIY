--三叶草or四叶草
function c1111001.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COIN+CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111001)
	e1:SetTarget(c1111001.tg1)
	e1:SetOperation(c1111001.op1)
	c:RegisterEffect(e1)
end
--
c1111001.named_with_Dw=1
function c1111001.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
function c1111001.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1111001.filter1(c,e,tp)
	return c1111001.IsLd(c)
end
function c1111001.filter2(c,e,tp)
	return c:IsCode(1111002) and c:IsAbleToHand()
end
function c1111001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c1111001.op1(e,tp,eg,ep,ev,re,r,rp)
	local r1,r2,r3=Duel.TossCoin(tp,3)
	if r1+r2+r3==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_SZONE,0,nil)
		local gn=Duel.SendtoHand(g,nil,REASON_EFFECT)
		if gn~=0 then
			Duel.Damage(tp,gn*800,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif r1+r2+r3==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c1111001.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
			Duel.ShuffleHand(tp)
		end
	elseif r1+r2+r3==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=Duel.SelectMatchingCard(tp,c1111001.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
		if g3:GetCount()>0 then
			local tc3=g3:GetFirst()
			if Duel.Remove(tc3,POS_FACEUP,REASON_EFFECT)~=0 and tc3:GetPreviousLocation()==LOCATION_DECK then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
