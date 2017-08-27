--概念礼装 元素转换
function c21401127.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c21401127.cost)
	e1:SetTarget(c21401127.target)
	e1:SetOperation(c21401127.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c21401127.eqlimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c21401127.value)
	c:RegisterEffect(e3)
	--Atk Def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--add counter
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c21401127.accon)
	e5:SetOperation(c21401127.acop)
	c:RegisterEffect(e5)
end
function c21401127.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf00)
end
function c21401127.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c21401127.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21401127.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401127.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c21401127.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c21401127.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c21401127.eqlimit(e,c)
	return c:IsSetCard(0xf00)
end
function c21401127.value(e,re,rp)
    local tc=re:GetHandler()
	return re:IsActiveType(TYPE_EQUIP) and re~=e:GetHandler() and tc:IsSetCard(0xf0b)
end
function c21401127.accon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
	and ev>=500
end
function c21401127.acop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetEquipTarget()
	local ct=math.floor(ev/500)
	tc:AddCounter(0xf0f,ct)
end