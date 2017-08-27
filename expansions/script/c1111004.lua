--蝶舞·梦落
function c1111004.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1111004.cost1)
	e1:SetTarget(c1111004.tg1)
	e1:SetOperation(c1111004.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c1111004.cost2)
	e2:SetTarget(c1111004.tg2)
	e2:SetOperation(c1111004.op2)
	c:RegisterEffect(e2)  
--  
end
--
c1111004.named_with_Dw=1
function c1111004.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111004.filter1(c)
	return c:IsAbleToDeckAsCost() and c:IsCode(1111001)
end
function c1111004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111004.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c1111004.filter1,tp,LOCATION_GRAVE,0,1,3,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1111004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
end
--
function c1111004.ofilter1(c,atk)
	return c:IsAbleToHand() and c:GetBaseAttack()<=atk and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1111004.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:SetLabel() and e:SetLabel()~=0 then
		local atk=e:GetLabel()*1500
		local g=Duel.GetMatchingGroup(c1111004.ofilter1,tp,0,LOCATION_MZONE,nil,atk)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
--
function c1111004.cfilter2(c)
	return c:IsCode(1111001) and c:IsFaceup() and c:IsAbleToDeck()
end
function c1111004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c1111004.cfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1111004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111004.cfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c1111004.cfilter2,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,g:GetCount(),tp,LOCATION_REMOVED)
end
--
function c1111004.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=Duel.GetMatchingGroup(c1111004.cfilter2,tp,LOCATION_REMOVED,0,nil)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
