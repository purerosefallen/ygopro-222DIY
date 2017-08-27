--精灵剑舞刻印
function c5200024.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c5200024.target)
	e1:SetOperation(c5200024.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c5200024.handcon)
	c:RegisterEffect(e2)
end

function c5200024.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x360)
end
function c5200024.handcon(e,tp,eg,ep,ev,re,r,rp)
 return  not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end

function c5200024.tcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x360) and Duel.IsExistingMatchingCard(c5200024.eqfilter,c:GetControler(),0x12,0,1,nil,c)
end
function c5200024.eqfilter(ec,tc)
	return ec:IsType(TYPE_EQUIP) and ec:CheckEquipTarget(tc)
end
function c5200024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(tp) and c5200024.tcfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c5200024.tcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c5200024.tcfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c5200024.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c5200024.eqfilter,tp,0x12,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(c5200024.efilter)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetOperation(c5200024.op)
			e2:SetLabelObject(e:GetHandler())
			tc:RegisterEffect(e2)
		end
	end
end
function c5200024.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c5200024.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(0)
	e:GetHandler():RegisterEffect(e1)
end
