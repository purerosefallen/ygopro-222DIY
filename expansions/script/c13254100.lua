--元始·飞球之帷幕
function c13254100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254100,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c13254100.cost)
	e1:SetTarget(c13254100.target)
	e1:SetOperation(c13254100.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254100,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c13254100.cost1)
	e2:SetTarget(c13254100.sptarget)
	e2:SetOperation(c13254100.spoperation)
	c:RegisterEffect(e2)
	
end
function c13254100.costfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and not c:IsPublic()
end
function c13254100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254100.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c13254100.costfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
end
function c13254100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c13254100.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c13254100.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST)
end
function c13254100.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and not c:IsPublic()
end
function c13254100.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254100.filter,tp,LOCATION_HAND,0,2,nil) end
	Duel.SetTargetPlayer(tp)
end
function c13254100.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(p,c13254100.filter,p,LOCATION_HAND,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.ConfirmCards(1-p,g)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c13254100.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p)
		Duel.ShuffleHand(p)
	end
end
function c13254100.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
