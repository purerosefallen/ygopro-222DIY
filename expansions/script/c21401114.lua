--塔拉斯克
function c21401114.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c21401114.eqtg)
	e1:SetOperation(c21401114.eqop)
	c:RegisterEffect(e1)
	--equip effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c21401114.eqcon1)
	e2:SetValue(2000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCondition(c21401114.eqcon1)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(1800)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c21401114.eqcon2)
	e4:SetValue(-2000)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCondition(c21401114.eqcon2)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(-1800)
	c:RegisterEffect(e5)
	--destroy sub
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCondition(c21401114.eqcon1)
	e6:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e6:SetValue(c21401114.repval)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetCondition(c21401114.eqcon3)
	e7:SetValue(c21401114.efilter)
	c:RegisterEffect(e7)
end
function c21401114.filter(c)
	return c:IsFaceup()
end
function c21401114.eqcon1(e)
	return e:GetHandler():GetEquipTarget():IsSetCard(0xf04)
end
function c21401114.eqcon2(e)
	return not e:GetHandler():GetEquipTarget():IsSetCard(0xf04)
end
function c21401114.eqcon3(e)
	return e:GetHandler():GetEquipTarget():IsCode(87355597)
end
function c21401114.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21401114.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c21401114.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c21401114.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
end
function c21401114.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c21401114.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c21401114.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c21401114.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c21401114.efilter(e,re)
	return e:GetHandler()~=re:GetHandler()
end