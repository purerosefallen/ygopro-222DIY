--lulutiye
function c16063020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,16063020)
	e1:SetTarget(c16063020.destg)
	e1:SetOperation(c16063020.desop)
	c:RegisterEffect(e1)
	--nageta
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16063020,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,16063020)
	e2:SetCondition(c16063020.ntcon)
	e2:SetOperation(c16063020.ntop)
	c:RegisterEffect(e2)
end
function c16063020.dfilter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c16063020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c16063020.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16063020.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16063020.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16063020.rfilter(c)
	return c:IsSetCard(0x5c5) and c:IsFaceup()
end
function c16063020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local d=Duel.GetMatchingGroupCount(c16063020.rfilter,tp,LOCATION_ONFIELD,0,nil)*400
			Duel.Recover(tp,d,REASON_EFFECT)
		end
	end
end
function c16063020.ntcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063020.ntop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(c16063020.discon)
	e1:SetOperation(c16063020.disop)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c16063020.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c16063020.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:GetHandlerPlayer()~=tp and (loc==LOCATION_GRAVE or loc==LOCATION_HAND or loc==LOCATION_DECK or loc==LOCATION_EXTRA or loc==LOCATION_REMOVED) then
		Duel.NegateEffect(ev)   
	end
end