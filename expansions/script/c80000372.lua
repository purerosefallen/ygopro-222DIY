--ＰＭ 电击兽
function c80000372.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),4,2)
	c:EnableReviveLimit() 
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c80000372.value)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(c80000372.rmtarget)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,80000372)
	e4:SetCost(c80000372.cost)
	e4:SetTarget(c80000372.destg)
	e4:SetOperation(c80000372.desop)
	c:RegisterEffect(e4)	
end
function c80000372.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000372.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) 
end
function c80000372.value(e,c)
	return Duel.GetMatchingGroupCount(c80000372.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)*200
end
function c80000372.rmtarget(e,c)
	local ty=c:GetOriginalType()
	return bit.band(ty,TYPE_SPELL+TYPE_TRAP)~=0 and c:IsFaceup() and not c:IsStatus(STATUS_ACTIVATE_DISABLED)
end
function c80000372.desfilter(c)
	return c:IsDestructable() and (c:GetSequence()==6 or c:GetSequence()==7)  
end
function c80000372.thfilter(c)
	return c:IsSetCard(0x2d0) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and c:IsAttackBelow(1500)
end
function c80000372.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c80000372.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000372.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
		and Duel.IsExistingMatchingCard(c80000372.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c80000372.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000372.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c80000372.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
