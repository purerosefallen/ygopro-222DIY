--架空吸血鬼 蕾米莉亚·斯卡雷特
function c8209705.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1212),4,2)
	c:EnableReviveLimit()  
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8209705,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c8209705.cost)
	e1:SetTarget(c8209705.target1)
	e1:SetOperation(c8209705.operation1)
	c:RegisterEffect(e1)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(8209705,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c8209705.rmcost)
	e5:SetTarget(c8209705.rmtg)
	e5:SetOperation(c8209705.rmop)
	c:RegisterEffect(e5)
end
function c8209705.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8209705.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1212)
end
function c8209705.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8209705.indfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c8209705.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c8209705.indtg)
	e1:SetValue(c8209705.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c8209705.indtg(e,c)
	return c:IsSetCard(0x1212) 
end
function c8209705.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
end
function c8209705.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c8209705.rmfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c8209705.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and c8209705.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8209705.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c8209705.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c8209705.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end