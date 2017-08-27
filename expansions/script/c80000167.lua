--口袋妖怪 巨钳螳螂
function c80000167.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),6,3)
	c:EnableReviveLimit()   
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000167,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c80000167.negcon)
	e1:SetOperation(c80000167.maop)
	e1:SetCost(c80000167.cost)
	c:RegisterEffect(e1)
	--Overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000167,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c80000167.con)
	e2:SetOperation(c80000167.op)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000167,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c80000167.damcon)
	e3:SetCost(c80000167.damcost)
	e3:SetOperation(c80000167.operation)
	c:RegisterEffect(e3)
end
function c80000167.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckPhaseActivity() and Duel.GetCurrentChain()==0
end
function c80000167.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	return tc and tc:IsFaceup() and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() and tc:GetAttack()<c:GetAttack()
end
function c80000167.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c80000167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000167.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000166) and Duel.GetCurrentPhase()==PHASE_MAIN1 
end
function c80000167.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,99,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c80000167.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,ct,ct,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c80000167.mfilter(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c80000167.maop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local ct=Duel.GetMatchingGroupCount(c80000167.mfilter,tp,0,LOCATION_MZONE,nil)
	if ct~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
		e:GetHandler():RegisterEffect(e1)
	end
end