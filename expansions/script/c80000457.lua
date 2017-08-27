--ＬＰＭ 雷电云·灵兽型态
function c80000457.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,111,111,c80000457.ovfilter,aux.Stringid(80000457,999),3,c80000457.xyzop)
	c:EnableReviveLimit()  
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80000457.efilter)
	c:RegisterEffect(e1)
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c80000457.effcon)
	c:RegisterEffect(e2) 
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000457,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80000457.tdcost2)
	e3:SetTarget(c80000457.rmtg1)
	e3:SetOperation(c80000457.rmop1)
	c:RegisterEffect(e3) 
end
function c80000457.cfilter(c)
	return c:IsCode(80000460) and c:IsDiscardable()
end
function c80000457.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80000456)
end
function c80000457.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000457.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80000457.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80000457.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c80000457.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000457.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000457.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,1-tp,LOCATION_EXTRA)
end
function c80000457.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,5,5,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
end
end
