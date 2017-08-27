--口袋妖怪 月亮岩
function c80000182.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80000182.condition)
	e1:SetCost(c80000182.cost)
	e1:SetOperation(c80000182.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,80000182+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c80000182.spcon)
	c:RegisterEffect(e2) 
end
function c80000182.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0)
end
function c80000182.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c80000182.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c80000182.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0)==0
end
function c80000182.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,80000182)==0 and e:GetHandler():IsAbleToGraveAsCost()
		and Duel.GetTurnPlayer()==tp end
	Duel.RegisterFlagEffect(tp,80000182,RESET_PHASE+PHASE_END,0,1)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c80000182.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetOperation(c80000182.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000182.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_DECK and ep~=tp then
		Duel.NegateEffect(ev)
	end
end