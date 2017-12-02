--忘却之海·Firce777
local m=66677789
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.discon1)
	e2:SetTarget(cm.distg2)
	e2:SetOperation(cm.disop1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.discon2)
	e2:SetTarget(cm.distg1)
	e2:SetOperation(cm.disop2)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return (e:GetHandler():GetPreviousPosition() & POS_FACEUP)~=0
			and (e:GetHandler():GetPreviousLocation() & LOCATION_ONFIELD)~=0
	end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local s0=Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_GRAVE,0,1,nil,0)
		local s1=Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_REMOVED,0,1,nil,1)
		if chk==0 then return s1 or s2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=nil
		if s0 and not s1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,3))
		elseif s1 and not s0 then
			op=Duel.SelectOption(tp,aux.Stringid(m,4))+1
		elseif s0 and s1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		end
		if op then e:SetLabel(op) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local op=e:GetLabel()
		local g=Group.CreateGroup()
		if op==0 and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_GRAVE,0,1,nil,0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_GRAVE,0,1,2,nil,0)   
		elseif op==1 and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_REMOVED,0,1,nil,1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_REMOVED,0,1,2,nil,1)
		end
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)   
	c:RegisterEffect(e4)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and ep~=tp and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_SEASERPENT)
end
function cm.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and rc:IsAbleToChangeControler() then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,1-tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(1-tp,m*16+5) then
			Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		else
			Duel.SendtoGrave(rc:GetOverlayGroup(),REASON_RULE)
			Duel.Overlay(c,rc)
		end
	end
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_FAIRY)
end
function cm.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local code=rc:GetCode()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,1-tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(1-tp,m*16+6) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemoveAsCost,1-tp,LOCATION_HAND,0,1,1,nil)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			e1:SetValue(cm.aclimit)
			e1:SetLabel(code)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.aclimit(e,re,tp)
	local code=e:GetLabel()
	return re:GetHandler():IsCode(code) and not re:GetHandler():IsImmuneToEffect(e)
end