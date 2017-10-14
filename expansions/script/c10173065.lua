--天星龙骑剑
function c10173065.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c10173065.linkfilter,2,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173065,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10173065)
	e1:SetCost(c10173065.eqcost)
	e1:SetTarget(c10173065.eqtg)
	e1:SetOperation(c10173065.eqop)
	c:RegisterEffect(e1)
	--ATKup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173065,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10173165)
	e2:SetCost(c10173065.atkcost)
	e2:SetOperation(c10173065.atkop)
	c:RegisterEffect(e2)
end
function c10173065.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	if chk==0 then return g:GetCount()>0 and g:IsExists(Card.IsAbleToRemoveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function c10173065.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c10173065.linkfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttackAbove(2000)
end
function c10173065.eqfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and (c:IsControler(tp) or (c:IsAbleToChangeControler() or c:IsLocation(LOCATION_GRAVE)))
end
function c10173065.rfilter(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsAbleToRemoveAsCost()
end
function c10173065.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173065.rfilter,tp,0x13,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10173065.rfilter,tp,0x13,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c10173065.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c10173065.eqfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c10173065.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler(),tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c10173065.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,LOCATION_GRAVE+LOCATION_MZONE)
end
function c10173065.eqop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)   
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_EFFECT)) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if Duel.Equip(tp,tc,c)==0 then return end
		local code=e:GetLabelObject():GetOriginalCode()
		local cid=tc:CopyEffect(code,RESET_EVENT+0x1fe0000)
		tc:SetHint(HINT_CARD,code)
	else Duel.SendtoGrave(tc,REASON_EFFECT) 
	end
end