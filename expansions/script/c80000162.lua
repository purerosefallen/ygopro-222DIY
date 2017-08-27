--口袋妖怪 3D龙Z
function c80000162.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),7,4)
	c:EnableReviveLimit() 
	--skip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000162,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c80000162.descost)
	e1:SetTarget(c80000162.damtg)
	e1:SetOperation(c80000162.damop)
	c:RegisterEffect(e1)   
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000162,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c80000162.descost1)
	e2:SetCondition(c80000162.descon)
	e2:SetOperation(c80000162.desop)
	c:RegisterEffect(e2)   
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000162,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c80000162.target)
	e3:SetOperation(c80000162.operation)
	c:RegisterEffect(e3)   
end
function c80000162.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c80000162.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.SelectOption(tp,60,61)
	local res=Duel.TossCoin(tp,1)
	if coin~=res then
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	else
		Duel.SetLP(tp,Duel.GetLP(tp)/2)
	end
end
function c80000162.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,80000161)
end
function c80000162.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000162.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,5,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,5,5,REASON_COST)
end
function c80000162.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetCondition(c80000161.skipcon)
	Duel.RegisterEffect(e1,tp)
end
function c80000162.skipcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c80000162.filter(c,tp)
	return c:IsPosition(POS_DEFENSE) and not c:IsType(TYPE_TOKEN)
		and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c80000162.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80000162.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c80000162.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c80000162.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
end
function c80000162.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end