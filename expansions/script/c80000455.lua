--ＬＰＭ 龙卷云·灵兽型态
function c80000455.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,111,111,c80000455.ovfilter,aux.Stringid(80000455,999),3,c80000455.xyzop)
	c:EnableReviveLimit()  
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80000455.efilter)
	c:RegisterEffect(e1)
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c80000455.effcon)
	c:RegisterEffect(e2) 
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000455,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80000455.tdcost2)
	e3:SetTarget(c80000455.tdtg2)
	e3:SetOperation(c80000455.tdop2)
	c:RegisterEffect(e3) 
end
function c80000455.cfilter(c)
	return c:IsCode(80000460) and c:IsDiscardable()
end
function c80000455.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80000454)
end
function c80000455.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000455.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80000455.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80000455.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c80000455.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000455.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000455.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c80000455.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000455.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c80000455.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c80000455.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c80000455.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			c:RegisterFlagEffect(80000455,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,0)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
end