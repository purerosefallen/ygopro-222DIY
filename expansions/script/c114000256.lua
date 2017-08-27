--★昴（すばる）の魔法少女　宇佐木里美
function c114000256.initial_effect(c)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000256.condition)
	e1:SetCost(c114000256.cost)
	e1:SetTarget(c114000256.target)
	e1:SetOperation(c114000256.operation)
	c:RegisterEffect(e1)
end

function c114000256.cfilter(c)
	return c:IsFaceup() 
	and ( c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) ) --0x224
end
function c114000256.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c114000256.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	and not e:GetHandler():IsStatus(STATUS_CHAINING)
end

function c114000256.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end

function c114000256.filter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsLevelBelow(4) and c:IsControlerCanBeChanged()
end
function c114000256.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c114000256.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114000256.filter,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c114000256.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function c114000256.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local tct=1
	if Duel.GetTurnPlayer()~=tp then tct=2 end
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp,PHASE_END,tct) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
	if c:IsRelateToEffect(e) then 
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT) 
	end
end