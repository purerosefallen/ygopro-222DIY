--最后一线的希望
function c5800031.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5800031)
	e1:SetCondition(c5800031.con1)
	e1:SetCost(c5800031.cost1)
	e1:SetTarget(c5800031.tg1)
	e1:SetOperation(c5800031.op1)
	c:RegisterEffect(e1)	  
--	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,5800032)
	e2:SetCost(c5800031.cost2)
	e2:SetCondition(c5800031.con2)
	e2:SetOperation(c5800031.op2)
	c:RegisterEffect(e2)
end
--
function c5800031.con1(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
--
function c5800031.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local LP=Duel.GetLP(tp)
	local cost=LP/2
	if chk==0 then return Duel.CheckLPCost(tp,cost) end
	Duel.PayLPCost(tp,cost)
end
--
function c5800031.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	local sg=Duel.GetMatchingGroup(aux.TURE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
	if sg:GetCount()>3 then
	   Duel.SetChainLimit(c5800031.limit1)
	end
end
--
function c5800031.limit1(e,ep,tp)
	return tp==ep
end
--
function c5800031.ofilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function c5800031.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c5800031.ofilter1,nil)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if ct~=0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(5800031,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sdg=dg:Select(tp,1,ct,e:GetHandler())
		Duel.Destroy(sdg,REASON_EFFECT)
	end
end
--
function c5800031.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
--
function c5800031.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local LP=Duel.GetLP(tp)
	local cost=LP/2
	if chk==0 then return Duel.CheckLPCost(tp,cost) end
	Duel.PayLPCost(tp,cost)
end
--
function c5800031.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 then
		Duel.SortDecktop(tp,tp,5)
	end
end

