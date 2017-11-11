--禁忌『笼女游戏』
function c1152304.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c1152304.con1)
	e1:SetTarget(c1152304.tg1)
	e1:SetOperation(c1152304.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1152304)
	e2:SetCondition(c1152304.con2)
	e2:SetCost(c1152304.cost2)
	e2:SetTarget(c1152304.tg2)
	e2:SetOperation(c1152304.op2)
	c:RegisterEffect(e2)   
end
--
function c1152304.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
c1152304.named_with_Fulsp=1
function c1152304.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Fulsp
end
--
function c1152304.cfilter1(c)
	return c1152304.IsFulan(c) and c:IsFaceup()
end
function c1152304.con1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg:IsExists(c1152304.cfilter1,1,nil) and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
--
function c1152304.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
		end
	end
	Duel.SetChainLimit(aux.FALSE)   
end
--
function c1152304.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(1-tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
--
function c1152304.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT) and c1152304.IsFulan(c)
end
function c1152304.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1152304.cfilter2,1,nil,tp)
end
--
function c1152304.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1152304.tfilter2(c)
	return c:IsAbleToDeckAsCost()
end
function c1152304.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1152304.tfilter2,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_ONFIELD)
end
--
function c1152304.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1152304.tfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tc:GetControler())
			tc:ReverseInDeck()
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetCategory(CATEGORY_DESTROY)
			e2_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e2_1:SetCode(EVENT_TO_HAND)
			e2_1:SetTarget(c1152304.tg2_1)
			e2_1:SetOperation(c1152304.op2_1)
			e2_1:SetReset(RESET_EVENT+0x1de0000)
			tc:RegisterEffect(e2_1)
		end
	end
end
--
function c1152304.tg2_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	end
end
--
function c1152304.ofilter2_1(c)
	return c:IsDestructable()
end
function c1152304.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(1-tp,c1152304.ofilter2_1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.Destroy(g2,REASON_EFFECT)
	end
end

