--ex-肾杯
function c80007032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80007032.target)
	e1:SetOperation(c80007032.activate)
	c:RegisterEffect(e1)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80007032,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,80007032)
	e4:SetCondition(c80007032.condition)
	e4:SetCost(c80007032.tgcost)
	e4:SetTarget(c80007032.tgtg)
	e4:SetOperation(c80007032.tgop)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e4)
end
function c80007032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,4) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c80007032.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.Draw(tp,2,REASON_EFFECT)
	else Duel.Draw(1-tp,4,REASON_EFFECT) end
end
function c80007032.cfilter(c)
	return c:IsFaceup() and c:IsCode(80007030)
end
function c80007032.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c80007032.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c80007032.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80007032.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c80007032.tgop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
