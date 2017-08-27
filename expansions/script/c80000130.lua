--口袋妖怪 导电飞鼠
function c80000130.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),2,2)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,80000130)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c80000130.condition)
	e1:SetCost(c80000130.cost)
	e1:SetOperation(c80000130.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80000130.econ)
	c:RegisterEffect(e2)
end
function c80000130.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP+TYPE_SPELL)
end
function c80000130.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c80000130.activate(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetOperation(c80000130.thop)
		e1:SetReset(RESET_EVENT+0x17a0000)
		re:GetHandler():RegisterEffect(e1)
	end
end
function c80000130.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
	end
end
function c80000130.econ(e)
	return e:GetHandler():GetOverlayCount()==0
end