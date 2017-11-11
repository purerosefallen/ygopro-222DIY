--灵曲·拂晓繁华之风
function c1111222.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111222,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1111222)
	e1:SetTarget(c1111222.tg1)
	e1:SetOperation(c1111222.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111222,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1111227) 
	e2:SetCost(c1111222.cost2)
	e2:SetTarget(c1111222.tg2)
	e2:SetOperation(c1111222.op2)
	c:RegisterEffect(e2)
--
end
--
c1111222.named_with_Lq=1
function c1111222.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1111222.tfilter1(c)
	return c:IsAbleToHand()
end
function c1111222.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(c1111222.tfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c1111222.tfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RTOHAND,g,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,LOCATION_ONFIELD)
	Duel.SetChainLimit(c1111222.limit1_1(g:GetFirst()))
end
function c1111222.limit1_1(c)
	return  
	function (e,lp,tp)
		return e:GetHandler() ~= c
	end
end
--
function c1111222.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_ONFIELD) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			c:AddCounter(0x1111,1)
		end
	end
end
--
function c1111222.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1111,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1111,1,REASON_COST)
end
--
function c1111222.tfilter2(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x1111,1) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c1111222.IsLq(c)
end
function c1111222.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1111222.tfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,LOCATION_ONFIELD)
end
--
function c1111222.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c1111222.tfilter2,tp,0,LOCATION_DECK,1,2,e:GetHandler())
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				tc:AddCounter(0x1111,1)
				tc=g:GetNext()
			end
		end
	end
end
--