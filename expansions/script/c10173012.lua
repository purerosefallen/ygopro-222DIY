--雷龙剑
function c10173012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10173012.target)
	e1:SetOperation(c10173012.operation)
	c:RegisterEffect(e1) 
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10173012.eqlimit)
	c:RegisterEffect(e2) 
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(600)
	c:RegisterEffect(e3) 
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	--effects
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10173012,0))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_REMOVE)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,10173012)
	e7:SetCost(c10173012.cost)
	e7:SetTarget(c10173012.target2)
	e7:SetOperation(c10173012.operation2)
	c:RegisterEffect(e7)
end
function c10173012.rfilter(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and (c:IsFaceup() or not c:IsLocation(LOCATION_SZONE)) and c:IsAbleToRemoveAsCost()
end
function c10173012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173012.rfilter,tp,LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10173012.rfilter,tp,LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10173012.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if c:IsAbleToHand() then sel=sel+1 end
		if Duel.IsExistingTarget(c10173012.filter,tp,LOCATION_MZONE,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(10173012,1),aux.Stringid(10173012,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10173012,1))
	else
		Duel.SelectOption(tp,aux.Stringid(10173012,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	else
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_EQUIP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.SelectTarget(tp,c10173012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	end
end
function c10173012.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	if sel==1 then
	   Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
	   local tc=Duel.GetFirstTarget()
	   if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		  Duel.Equip(tp,c,tc)
	   end
	end
end
function c10173012.eqlimit(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c10173012.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c10173012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10173012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10173012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10173012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10173012.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end