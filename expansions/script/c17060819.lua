--暗堕型佣兵亚瑟
function c17060819.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),7,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060819,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060819,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,17060819)
	e2:SetTarget(c17060819.pctg)
	e2:SetOperation(c17060819.pcop)
	c:RegisterEffect(e2)
	--negate+atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060819,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c17060819.necost)
	e3:SetTarget(c17060819.netg)
	e3:SetOperation(c17060819.neop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060819,4))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--pendulum set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17060819,5))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c17060819.penon)
	e5:SetTarget(c17060819.pentg)
	e5:SetOperation(c17060819.penop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(c17060819.penon1)
	c:RegisterEffect(e6)
end
c17060819.pendulum_level=7
c17060819.is_named_with_Mercenary_Arthur=1
c17060819.is_named_with_Million_Arthur=1
c17060819.is_named_with_Dark_Degenerate=1
function c17060819.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060819.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060819.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060819.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060819.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c17060819.pcfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c17060819.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17060819.pcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c17060819.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17060819.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c17060819.netg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c17060819.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060819.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17060819.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c17060819.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_ATTACK)
		e3:SetValue(tc:GetBaseAttack()/2)
		tc:RegisterEffect(e3)
	end
end
function c17060819.penon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
	and Duel.GetMZoneCount(tp)>0)
end
function c17060819.penon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
	and Duel.GetMZoneCount(tp)>0
end
function c17060819.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17060819.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end