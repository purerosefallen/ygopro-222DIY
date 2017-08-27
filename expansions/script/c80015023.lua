--反叛者之灵
function c80015023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,80015023+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80015023.cost)
	e1:SetCondition(c80015023.condition)
	e1:SetTarget(c80015023.target)
	e1:SetOperation(c80015023.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80015023.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,80015024)
	e4:SetCost(c80015023.negcost)
	e4:SetOperation(c80015023.activate1)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(80015023,ACTIVITY_SPSUMMON,c80015023.counterfilter)
end
function c80015023.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c80015023.cfilter(c)
	return c:IsSetCard(0x32d7) and c:IsAbleToDeckAsCost()
end
function c80015023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80015023.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetCustomActivityCount(80015023,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c80015023.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80015023.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c80015023.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK) 
end
function c80015023.filter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_DARK) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c80015023.handcon(e)
	return not Duel.IsExistingMatchingCard(c80015023.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c80015023.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c80015023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c80015023.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
		Duel.Recover(1-tp,1000,REASON_EFFECT)
	end
end  
function c80015023.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80015023.activate1(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SUMMON_SUCCESS)
		e4:SetCondition(c80015023.sumcon)
		e4:SetOperation(c80015023.sumsuc)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e5,tp)
		local e6=e4:Clone()
		e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(e6,tp)
end
function c80015023.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80015023.filter2,1,nil)
end
function c80015023.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c80015023.efun)
end
function c80015023.efun(e,ep,tp)
	return ep==tp
end
function c80015023.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end