--灵气枯竭
function c13254113.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254113,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13254113+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c13254113.condition)
	e1:SetCost(c13254113.cost)
	e1:SetTarget(c13254113.target)
	e1:SetOperation(c13254113.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetTarget(c13254113.reptg)
	e2:SetValue(c13254113.repval)
	e2:SetOperation(c13254113.repop)
	c:RegisterEffect(e2)
	
end
function c13254113.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_HAND,0)==1
end
function c13254113.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x356) and c:IsAbleToRemoveAsCost()
end
function c13254113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254113.costfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetCurrentPhase()==PHASE_MAIN1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c13254113.costfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13254113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	if ct==3 then Duel.SetChainLimit(aux.FALSE) end
end
function c13254113.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c13254113.repfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c13254113.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ((c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()) or (c:IsLocation(LOCATION_HAND) and c:IsDiscardable())) and eg:IsExists(c13254113.repfilter,1,nil,1-tp) end
	return (c:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(13254113,0))) or (c:IsLocation(LOCATION_GRAVE) and Duel.SelectYesNo(tp,aux.Stringid(13254113,1)))
end
function c13254113.repval(e,c)
	return c13254113.repfilter(c,1-e:GetHandlerPlayer())
end
function c13254113.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	elseif c:IsLocation(LOCATION_HAND) then Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD) end
end
