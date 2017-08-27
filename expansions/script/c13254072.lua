--飞球之仁慈
function c13254072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254072,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c13254072.cost1)
	e1:SetCondition(c13254072.condition)
	e1:SetTarget(c13254072.target)
	e1:SetOperation(c13254072.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254072,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(c13254072.cost1)
	e2:SetCountLimit(1,13254072+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c13254072.condition1)
	e2:SetTarget(c13254072.target1)
	e2:SetOperation(c13254072.activate1)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c13254072.handcon)
	c:RegisterEffect(e3)
	
end
function c13254072.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254072.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254072.costfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c13254072.costfilter,tp,LOCATION_HAND,0,2,2,nil)
		Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
end
function c13254072.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c13254072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c13254072.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsCanTurnSet() and rc:IsRelateToEffect(re) then
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		rc:SetStatus(STATUS_SET_TURN,false)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		e1:SetValue(1)
		rc:RegisterEffect(e1)
	end
end
function c13254072.condition1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_HAND or loc==LOCATION_GRAVE) and Duel.IsChainNegatable(ev)
end
function c13254072.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c13254072.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c13254072.handcon(e)
	return Duel.IsExistingMatchingCard(c13254072.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c13254072.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x356)
end
