--Solid 一零零一
function c22240121.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,0x81),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22240121,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22240121.xyzcon)
	e1:SetOperation(c22240121.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22240121,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetCost(c22240121.cost)
	e2:SetCondition(c22240121.condition)
	e2:SetTarget(c22240121.target)
	e2:SetOperation(c22240121.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22240121,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,22240121)
	e3:SetCost(c22240121.thcost)
	e3:SetTarget(c22240121.thtg)
	e3:SetOperation(c22240121.thop)
	c:RegisterEffect(e3)
end
c22240121.named_with_Solid=1
function c22240121.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22240121.xyzfilter(c,xyzc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and bit.band(c:GetOriginalType(),0x81)==0x81
end
function c22240121.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_XMATERIAL) then return false end
	local olg=Duel.GetMatchingGroup(c22240121.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then return true end
end
function c22240121.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local olg=Duel.GetMatchingGroup(c22240121.xyzfilter,tp,LOCATION_SZONE,0,nil,c)
	if olg:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,olg,c)>0 then
		local g=olg:Select(tp,2,2,nil)
		c:SetMaterial(g)
		Duel.Overlay(c,g)
	end
end
function c22240121.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)==0
end
function c22240121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c22240121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c22240121.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetTurnPlayer()==tp then
		local ph=Duel.GetCurrentPhase()
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(0,1)
		e3:SetValue(c22240121.aclimit)
		e3:SetReset(RESET_PHASE+ph)
		Duel.RegisterEffect(e3,tp)
	end
end
function c22240121.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c22240121.filter(c)
	return c:IsType(TYPE_MONSTER) and bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsAbleToHand()
end
function c22240121.thcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c22240121.reop)
		Duel.RegisterEffect(e1,tp)
end
function c22240121.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c22240121.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22240121.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22240121.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22240121.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c22240121.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end