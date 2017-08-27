--寒冰元素
function c8209701.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1212),4,2)
	c:EnableReviveLimit()
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8209701,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,8209701)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(c8209701.descost)
	e3:SetTarget(c8209701.destg)
	e3:SetOperation(c8209701.desop)
	c:RegisterEffect(e3)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8209701,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE)
	e2:SetCountLimit(1,8209701)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c8209701.cost)
	e2:SetOperation(c8209701.operation)
	c:RegisterEffect(e2)
end
function c8209701.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8209701.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function c8209701.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c8209701.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8209701.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c8209701.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c8209701.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c8209701.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and c:GetFlagEffect(8209701)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	c:RegisterFlagEffect(8209701,RESET_CHAIN,0,1)
end
function c8209701.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c8209701.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c8209701.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end