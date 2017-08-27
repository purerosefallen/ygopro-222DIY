--俺の屍を越えてゆけ
function c114000484.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c114000484.condition)
	e2:SetTarget(c114000484.target)
	e2:SetOperation(c114000484.operation)
	c:RegisterEffect(e2)
end
function c114000484.cfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsLevelAbove(2) and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000484.condition(e,tp,eg,ep,ev,re,r,rp)
	local lv=0
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_DESTROY) and ( tc:IsSetCard(0x221) or tc:IsCode(114000231) ) and rp~=tp then --caused by opponent
			local tlv=tc:GetLevel()
			if tlv>lv then lv=tlv end
		end
		tc=eg:GetNext()
	end
	if lv>1 then e:SetLabel(lv) end --must be level 2+
	return lv>1
end
function c114000484.filter(c,lv)
	local slv=lv-1
	return c:IsLevelBelow(slv) and ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsAbleToHand()
end
function c114000484.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.IsExistingMatchingCard(c114000484.filter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114000484.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c114000484.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end