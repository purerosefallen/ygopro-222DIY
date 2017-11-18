--对碑文的解读
function c22252201.initial_effect(c)
	c:SetUniqueOnField(1,0,22252201)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c22252201.activate)
	c:RegisterEffect(e1)
	--ANNOUNCE_CARD
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22252201.target)
	e2:SetOperation(c22252201.operation)
	c:RegisterEffect(e2)
   --activate in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(c22252201.eefilter))
	c:RegisterEffect(e3)
end
c22252201.named_with_Riviera=1
function c22252201.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22252201.thfilter(c)
	return c22252201.IsRiviera(c) and c:IsAbleToHand()
end
function c22252201.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c22252201.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22252201,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c22252201.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c22252201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c22252201.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c22252201.announce_filter2={22251001,OPCODE_ISCODE,22251002,OPCODE_ISCODE,22251101,OPCODE_ISCODE,22251201,OPCODE_ISCODE,22251501,OPCODE_ISCODE,22252001,OPCODE_ISCODE,22252101,OPCODE_ISCODE,22252201,OPCODE_ISCODE,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c22252201.announce_filter2)) 
	c:SetHint(CHINT_CARD,ac)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22252201.spcon)
	e1:SetTarget(c22252201.sptg)
	e1:SetOperation(c22252201.spop)
	e1:SetLabel(ac)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c22252201.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
function c22252201.tehfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c22252201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22252201.tehfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c22252201.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c22252201.tehfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22252201.eefilter(c)
	return c22252201.IsRiviera(c)
end