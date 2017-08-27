--超时空武装 装甲-打火石
function c13257315.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257315.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257315.econ)
	e12:SetValue(c13257315.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetCondition(c13257315.atkcon)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(-1500)
	e2:SetCondition(c13257315.atkcon)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetCondition(c13257315.indcon)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257315,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c13257315.eqcon)
	e4:SetTarget(c13257315.eqtg)
	e4:SetOperation(c13257315.eqop)
	c:RegisterEffect(e4)
	--reequip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13257315,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,13257315)
	e5:SetCondition(c13257315.eqcon2)
	e5:SetTarget(c13257315.eqtg2)
	e5:SetOperation(c13257315.eqop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	
end
function c13257315.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x5352)
end
function c13257315.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257315.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257315.atkcon(e)
	return not e:GetHandler():GetEquipTarget():IsSetCard(0x351)
end
function c13257315.indcon(e)
	return e:GetHandler():GetEquipTarget():IsSetCard(0x351)
end
function c13257315.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget() and c:GetEquipTarget():IsSetCard(0x351)
end
function c13257315.eqfilter(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function c13257315.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13257315.eqfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c13257315.eqfilter,tp,0,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c13257315.eqfilter,tp,0,LOCATION_MZONE,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c13257315.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c13257315.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec
end
function c13257315.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13257315.eqfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c13257315.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c13257315.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
