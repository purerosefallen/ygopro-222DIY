--沉寂的暗影
function c22200001.initial_effect(c)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22200001,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SSET)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCondition(c22200001.con)
	e2:SetCost(c22200001.cost)
	e2:SetTarget(c22200001.tg)
	e2:SetOperation(c22200001.op)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22200001,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22200001+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c22200001.target)
	e3:SetOperation(c22200001.operation)
	c:RegisterEffect(e3)
	if c22200001.counter==nil then
		c22200001.counter=true
		c22200001[0]=0
		c22200001[1]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c22200001.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_SSET)
		e5:SetOperation(c22200001.addcount)
		Duel.RegisterEffect(e5,0)
	end
end
function c22200001.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK+LOCATION_GRAVE)
end
function c22200001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22200001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,0,0,0)
end
function c22200001.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoHand(eg,nil,REASON_EFFECT)<1 then return end
	Duel.BreakEffect()
	--cannot set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--cannot trigger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTarget(c22200001.distg)
	Duel.RegisterEffect(e3,tp)
end
function c22200001.distg(e,c)
	return c:IsFacedown()
end
function c22200001.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c22200001[0]=0
	c22200001[1]=0
end
function c22200001.adfilter(c)
	return c:IsLocation(LOCATION_SZONE)
end
function c22200001.addcount(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	c22200001[rp]=c22200001[rp]+eg:FilterCount(c22200001.adfilter,nil)
end
function c22200001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return c22200001[1-tp]>2 and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c22200001.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end