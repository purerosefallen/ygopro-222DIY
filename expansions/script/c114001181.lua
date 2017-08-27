--不屈の闘志
function c114001181.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c114001181.condition)
	e1:SetTarget(c114001181.target)
	e1:SetOperation(c114001181.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c114001181.handcon)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,114001181)
	e3:SetCondition(c114001181.thcon)
	e3:SetCost(c114001181.thcost)
	e3:SetTarget(c114001181.thtg)
	e3:SetOperation(c114001181.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c114001181.thcon2)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_DAMAGE)
	e5:SetCondition(c114001181.thcon3)
	c:RegisterEffect(e5)
end
function c114001181.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and Duel.IsDamageCalculated() then return false end
	return true
end
function c114001181.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x221)
end
function c114001181.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c114001181.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114001181.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c114001181.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c114001181.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(800)
		tc:RegisterEffect(e1)
	end
end

function c114001181.hdfilter(c)
	return c:IsFaceup() and ( c:IsLevelAbove(5) or c:IsType(TYPE_XYZ) )
end
function c114001181.handcon(e)
	return Duel.IsExistingMatchingCard(c114001181.hdfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end

function c114001181.reasfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x221) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c114001181.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c114001181.reasfilter,1,nil,tp)
end

function c114001181.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114001181.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c114001181.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end

function c114001181.reasfilter2(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c114001181.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c114001181.reasfilter2,1,nil,tp)
end

function c114001181.thcon3(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end