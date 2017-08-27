--概念礼装 万华镜
function c21401129.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c21401129.cost)
	e1:SetTarget(c21401129.target)
	e1:SetOperation(c21401129.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c21401129.eqlimit)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c21401129.value)
	c:RegisterEffect(e3)
	--Atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
end
function c21401129.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf00)
end
function c21401129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c21401129.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21401129.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401129.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c21401129.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c21401129.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsType(TYPE_XYZ) then 
		lv=tc:GetRank()
	elseif tc:IsType(TYPE_MONSTER) then
		lv=tc:GetLevel()
	end
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Equip(tp,e:GetHandler(),tc) and lv>=3 then
		tc:AddCounter(0xf0f,math.floor(lv/3))
		else 
		tc:AddCounter(0xf0f,1)
        end
	end
end
function c21401129.eqlimit(e,c)
	return c:IsSetCard(0xf00)
end
function c21401129.value(e,re,rp)
    local tc=re:GetHandler()
	return re:IsActiveType(TYPE_EQUIP) and re~=e:GetHandler() and tc:IsSetCard(0xf0b)
end