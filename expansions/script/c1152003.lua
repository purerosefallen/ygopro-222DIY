--破灭的波纹·芙兰朵露
function c1152003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c1152003.con1)
	e1:SetOperation(c1152003.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1152003.cost2)
	e2:SetTarget(c1152003.tg2)
	e2:SetOperation(c1152003.op2)
	c:RegisterEffect(e2)
--
end
--
c1152003.named_with_Fulan=1
function c1152003.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152003.named_with_Fulsp=1
function c1152003.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152003.cfilter1_1(c)
	return c:IsType(TYPE_MONSTER)
end
function c1152003.cfilter1_2(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c1152003.IsFulsp(c) and c:IsSSetable() and c:GetReason()==REASON_DESTROY 
end
function c1152003.con1(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(c1152003.cfilter1_1,tp,LOCATION_ONFIELD,0,nil)==0 and Duel.GetMatchingGroupCount(c1152003.cfilter1_2,tp,LOCATION_GRAVE,0,nil)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
--
function c1152003.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c1152003.cfilter1_2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SSet(tp,g)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c1152003.cfilter2_1(c)
	return c1152003.IsFulsp(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToRemoveAsCost()
end
function c1152003.cfilter2_2(c,code)
	return c:GetCode()==code and c:IsAbleToHand()
end
function c1152003.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local gn=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(c1152003.cfilter2_1,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetCode()
			local g2=Duel.GetMatchingGroup(c1152003.cfilter2_2,LOCATION_DECK,0,1,nil,code)
			if g2:GetCount()>0 then
				gn:AddCard(tc)
			end
			tc=g:GetNext()
		end
	end
	if chk==0 then return gn:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=gn:FilterSelect(tp,c1152003.cfilter2_1,1,1,nil)
	local tc3=g3:GetFirst()
	e:SetLabelObject(tc3)
	Duel.Remove(g3,POS_FACEUP,REASON_COST)
end
--
function c1152003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1152003.ofilter2(c,code)
	return c:GetCode()==code and c1152003.IsFulsp(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function c1152003.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1152003.ofilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e2_1=Effect.CreateEffect(e:GetHandler())
				e2_1:SetCode(EFFECT_CHANGE_TYPE)
				e2_1:SetType(EFFECT_TYPE_SINGLE)
				e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2_1:SetReset(RESET_EVENT+0x1fc0000)
				e2_1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e:GetHandler():RegisterEffect(e2_1,true)
			end
		end
	end
end
--
