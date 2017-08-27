--口袋妖怪 Mega喷火龙Y
function c80000084.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),8,3,c80000084.ovfilter,aux.Stringid(80000084,0),3,c80000084.xyzop)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000) 
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000084.splimit)
	c:RegisterEffect(e4)  
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000084,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c80000084.damcon)
	e1:SetTarget(c80000084.damtg)
	e1:SetOperation(c80000084.damop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetValue(c80000084.efilter)
	c:RegisterEffect(e12) 
	--
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_REMOVE)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetCost(c80000084.cost)
	e12:SetCondition(c80000084.condition)
	e12:SetTarget(c80000084.target)
	e12:SetOperation(c80000084.operation)
	c:RegisterEffect(e12)
end
function c80000084.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000008)
end
function c80000084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000084.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c80000084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80000084.tgfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c80000084.filter(c)
	return c:IsType(TYPE_SPELL) 
end
function c80000084.operation(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if conf:GetCount()>0 then
		Duel.ConfirmCards(tp,conf)
		local dg=conf:Filter(c80000084.filter,nil)
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
end
end
function c80000084.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c80000084.cfilter(c)
	return c:IsCode(80000060) and c:IsDiscardable()
end
function c80000084.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80000008)
end
function c80000084.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000084.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80000084.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80000084.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c80000084.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	e:GetHandler():RegisterFlagEffect(c80000084,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c80000084.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c80000084.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end