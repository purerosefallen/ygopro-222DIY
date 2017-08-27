--鬼缚印
function c10113007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,10113007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10113007.target)
	e1:SetOperation(c10113007.activate)
	c:RegisterEffect(e1)	
end
function c10113007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10113007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   tc:RegisterFlagEffect(10113007,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,2)
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	   e1:SetLabel(Duel.GetTurnCount()+1)
	   e1:SetLabelObject(tc)
	   e1:SetCountLimit(1)
	   e1:SetCondition(c10113007.retcon)
	   e1:SetOperation(c10113007.retop)
	   e1:SetReset(RESET_PHASE+PHASE_END,2)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c10113007.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel() and e:GetLabelObject():GetFlagEffect(10113007)~=0
end
function c10113007.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10113007)
	local c=e:GetLabelObject()
	c:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetValue(e:GetOwnerPlayer())
	e1:SetReset(RESET_EVENT+0xec0000)
	c:RegisterEffect(e1)
end