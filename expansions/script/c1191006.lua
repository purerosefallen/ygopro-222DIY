--ELF·茑萝魔弹
function c1191006.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,1191006)
	e1:SetCondition(c1191006.con1)
	e1:SetTarget(c1191006.tg1)
	e1:SetOperation(c1191006.op1)
	c:RegisterEffect(e1)  
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1191006.cost2)
	e2:SetTarget(c1191006.tg2)
	e2:SetOperation(c1191006.op2)
	c:RegisterEffect(e2)	  
end
--
c1191006.named_with_ELF=1
function c1191006.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1191006.confilter(c)
	return c:IsFaceup() and c1191006.IsELF(c) and c:IsType(TYPE_MONSTER)
end
function c1191006.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1191006.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c1191006.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c1191006.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c1191006.filter(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c1191006.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c1191006.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
--
function c1191006.op1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local atk=tg:GetTextAttack()
	if atk<0 then atk=0 end
	Duel.Damage(1-tp,atk/2,REASON_EFFECT)
end
--
function c1191006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c1191006.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c1191006.filter2(c)
	return c:IsCode(1190005) and c:IsAbleToGrave()
end
function c1191006.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1191006.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c1191006.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1191006.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

