--龙卷风2号
function c13255202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c13255202.target)
	e1:SetOperation(c13255202.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c13255202.eqlimit)
	c:RegisterEffect(e2)
	--Atk,def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(2500)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_LEVEL)
	e5:SetValue(3)
	c:RegisterEffect(e5)
	--destroy sub
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--cannot target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_EQUIP)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_GRAVE)
	e9:SetCountLimit(1,13255202)
	e9:SetCost(c13255202.cost)
	e9:SetTarget(c13255202.eqtg)
	e9:SetOperation(c13255202.operation)
	c:RegisterEffect(e9)
	
end
function c13255202.eqlimit(e,c)
	return c:IsRace(RACE_BEASTWARRIOR)
end
function c13255202.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR)
end
function c13255202.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c13255202.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13255202.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tg=Duel.SelectTarget(tp,c13255202.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	local tc=tg:GetFirst()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c13255202.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	tc:RegisterEffect(e1)
end
function c13255202.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c13255202.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c13255202.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and c:IsLevelBelow(1)
end
function c13255202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c13255202.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13255202.filter1(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c13255202.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c13255202.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
