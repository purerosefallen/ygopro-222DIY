--食人宝箱国王
function c10173035.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2,c10173035.ovfilter,aux.Stringid(10173035,0),2,nil)
	c:EnableReviveLimit()
	--immune (FAQ in Card Target)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c10173035.target)
	e1:SetValue(c10173035.efilter)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10173035,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetCost(c10173035.indcost)
	e6:SetTarget(c10173035.indtg)
	e6:SetOperation(c10173035.indop)
	c:RegisterEffect(e6)
	e1:SetLabel(0)
	e2:SetLabel(1)
	e3:SetLabel(2)
	e4:SetLabel(3)
	e5:SetLabel(4)
end
function c10173035.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10173035.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c10173035.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c10173035.ovfilter(c)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (rk==1 or rk==2) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10173035.target(e,c)
	return c:GetSequence()==e:GetLabel()
end
function c10173035.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_MZONE,e:GetLabel()))
end