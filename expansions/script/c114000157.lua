--見られた魔法を使う姿
function c114000157.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c114000157.condition)
	e1:SetCost(c114000157.cost)
	e1:SetTarget(c114000157.target)
	e1:SetOperation(c114000157.activate)
	c:RegisterEffect(e1)
end
function c114000157.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c114000157.cfilter(c)
	return ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) --0x224
	or c:IsSetCard(0xcabb) ) 
	and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c114000157.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000157.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c114000157.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	--Duel.ShuffleDeck(tp)
end
function c114000157.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c114000157.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetOperation(c114000157.operation)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)	
		end
	end
end
function c114000157.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(114000157,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end