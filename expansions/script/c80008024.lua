--冰霜咏者 凋零
function c80008024.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c80008024.matfil,8,2,nil,nil,2)   
	--summon,flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c80008024.handes)
	c:RegisterEffect(e1) 
	local e5=e1:Clone()
	e5:SetOperation(c80008024.handes1)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetOperation(c80008024.handes2)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetOperation(c80008024.handes3)
	c:RegisterEffect(e7)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c80008024.discost)
	e2:SetTarget(c80008024.target)
	e2:SetOperation(c80008024.operation)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c80008024.indcon1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
end
c80008024[0]=0
function c80008024.handes(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or loc~=LOCATION_HAND or id==c80008024[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	c80008024[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80008024,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.BreakEffect()
	else Duel.NegateEffect(ev) end
end
function c80008024.handes1(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or loc~=LOCATION_DECK or id==c80008024[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	c80008024[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80008024,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.BreakEffect()
	else Duel.NegateEffect(ev) end
end
function c80008024.handes2(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or loc~=LOCATION_GRAVE or id==c80008024[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	c80008024[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80008024,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.BreakEffect()
	else Duel.NegateEffect(ev) end
end
function c80008024.handes3(e,tp,eg,ep,ev,re,r,rp)
	local loc,id=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_CHAIN_ID)
	if ep==tp or loc~=LOCATION_REMOVED or id==c80008024[0] or not re:IsActiveType(TYPE_MONSTER) then return end
	c80008024[0]=id
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(80008024,0)) then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.BreakEffect()
	else Duel.NegateEffect(ev) end
end
function c80008024.matfil(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80008024.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c80008024.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d8) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c80008024.indcon1(e)
	return Duel.IsExistingMatchingCard(c80008024.indfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c80008024.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c80008024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80008024.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c80008024.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c80008024.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
end
function c80008024.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c80008024.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end