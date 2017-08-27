--口袋妖怪 3D龙II
function c80000161.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),5,3)
	c:EnableReviveLimit() 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000161,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,80000161)
	e1:SetCost(c80000161.thcost)
	e1:SetTarget(c80000161.thtg)
	e1:SetOperation(c80000161.thop)
	c:RegisterEffect(e1)
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000161,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,80000161)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c80000161.descost)
	e2:SetCondition(c80000161.descon)
	e2:SetOperation(c80000161.activate)
	c:RegisterEffect(e2)   
end
function c80000161.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c80000161.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c80000161.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c80000161.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_BATTLE then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c80000161.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c80000161.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c80000161.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000160)
end
function c80000161.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end