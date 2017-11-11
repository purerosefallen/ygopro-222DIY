--灵曲·彼岸盛开之花
function c1111221.initial_effect(c)
--
	c:EnableCounterPermit(0x1111)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111221,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1111221) 
	e1:SetCost(c1111221.cost1)
	e1:SetTarget(c1111221.tg1)
	e1:SetOperation(c1111221.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111221,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1111226) 
	e2:SetCost(c1111221.cost2)
	e2:SetTarget(c1111221.tg2)
	e2:SetOperation(c1111221.op2)
	c:RegisterEffect(e2)
end
--
c1111221.named_with_Lq=1
function c1111221.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1111221.cfilter1(c)
	return c:IsAbleToHandAsCost() and c:IsType(TYPE_MONSTER)
end
function c1111221.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111221.cfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c1111221.cfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
--
function c1111221.tfilter1(c)
	return c:IsAbleToGrave()
end
function c1111221.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111221.tfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
--
function c1111221.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)	
		local g=Duel.SelectMatchingCard(tp,c1111221.tfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				e:GetHandler():AddCounter(0x1111,1)
			end
		end
	end
end
--
function c1111221.cfilter2(c)
	return c:IsAbleToGrave() and c1111221.IsLq(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c1111221.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1111,2,REASON_COST) and Duel.IsExistingMatchingCard(c1111221.cfilter2,tp,LOCATION_DECK,0,2,nil) end
	local c=e:GetHandler()
	local num=0
	while c:IsCanRemoveCounter(tp,0x1111,1,REASON_COST) do
		num=num+1
		c:RemoveCounter(tp,0x1111,1,REASON_COST)
		if num>=2 then
			if c:IsCanRemoveCounter(tp,0x1111,1,REASON_COST) and Duel.IsExistingMatchingCard(c1111221.cfilter2,tp,LOCATION_DECK,0,num+1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111221,2)) then
			else
				break
			end
		end
	end
	e:SetLabel(num)
end
--
function c1111221.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111221.cfilter2,tp,LOCATION_DECK,0,2,nil) end
	if e:GetLabel() and e:GetLabel()>0 then
		local num=e:GetLabel()
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,num,tp,LOCATION_DECK)
	end
end
--
function c1111221.oftiler2(c)
	return c:IsAbleToRemove()
end
function c1111221.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if e:GetLabel() and e:GetLabel()>0 then
			local num=e:GetLabel()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c1111221.cfilter2,tp,LOCATION_DECK,0,num,num,nil)
			if g:GetCount()>0 then
				local numtograve=Duel.SendtoGrave(g,REASON_EFFECT)
				if numtograve>0 and Duel.IsExistingMatchingCard(c1111221.ofilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111221,3)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local g2=Duel.SelectTarget(tp,c1111221.ofilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,numtograve,nil)
					if g2:GetCount()>0 then
						Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
					end
				end
			end
		end
	end
end
--