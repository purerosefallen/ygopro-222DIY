--ADVANTURE WORLD
local m=37564530
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,2,cm.ovfilter,aux.Stringid(m,0),63,cm.xyzop)
	c:EnableReviveLimit()
	Senya.Nanahira(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetTarget(cm.target0)
	e1:SetOperation(cm.operation0)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Senya.DescriptionCost(Senya.RemoveOverlayCost(7)))
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsDiscardable()
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==37564765
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c,tp)
	return (c:IsControler(tp) or c:IsAbleToChangeControler()) and not c:IsType(TYPE_TOKEN)
end
function cm.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cm.filter(chkc,tp) and chkc~=e:GetHandler() and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
end
function cm.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Senya.OverlayCard(c,tc,true)
	end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1=nil
	if c:GetFlagEffect(m-4000)==0 then
		e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MONSTER_SSET)
		e1:SetValue(TYPE_TRAP)
		e1:SetReset(RESET_CHAIN)
		c:RegisterEffect(e1,true)
		c:RegisterFlagEffect(m-4000,RESET_CHAIN,0,1)
	end
	if chk==0 then
		local res=c:IsSSetable()
		e1:Reset()
		c:ResetFlagEffect(m-4000)
		return res
	end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() and not c:IsImmuneToEffect(e) then
		for i=3,6 do
			Duel.Hint(HINT_OPSELECTED,1-tp,m*16+i)
		end
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetCost(cm.cost2)
		e2:SetCondition(cm.condition2)
		e2:SetTarget(cm.target2)
		e2:SetOperation(cm.activate2)
		e2:SetReset(RESET_EVENT+0xfc0000)
		c:RegisterEffect(e2,true)
		c:RegisterFlagEffect(m,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN) then return true end
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsChainNegatable(ev) or (c:GetFlagEffect(m)==0 or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for i=7,10 do
		Duel.Hint(HINT_OPSELECTED,1-tp,m*16+i)
	end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end