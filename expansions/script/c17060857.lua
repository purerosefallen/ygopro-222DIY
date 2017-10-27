--闇堕型ランスロット
function c17060857.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),3,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060857,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,17060857)
	e1:SetCondition(c17060857.spcon)
	e1:SetTarget(c17060857.sptg)
	e1:SetOperation(c17060857.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c17060857.spcon1)
	c:RegisterEffect(e2)
	--change atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060857,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c17060857.eqcon)
	e3:SetCost(c17060857.eqcost)
	e3:SetTarget(c17060857.eqtg)
	e3:SetOperation(c17060857.eqop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060857,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c17060857.reptg)
	e4:SetValue(c17060857.repval)
	e4:SetOperation(c17060857.repop)
	c:RegisterEffect(e4)
end
c17060857.pendulum_level=3
c17060857.is_named_with_Dark_Degenerate=1
function c17060857.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060857.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060857.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060857.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c17060857.IsDark_Degenerate(c)
end
function c17060857.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060857.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060857.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c17060857.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060857.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060857.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c17060857.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17060857.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local bc=e:GetHandler():GetBattleTarget()
end
function c17060857.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if not Duel.Equip(tp,bc,c,true) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c17060857.eqlimit)
		bc:RegisterEffect(e1)
	else Duel.SendtoGrave(bc,REASON_EFFECT) end
end
function c17060857.eqlimit(e,c)
	return e:GetOwner()==c
end
function c17060857.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c17060857.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c17060857.repfilter,1,nil,tp)
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	return Duel.SelectYesNo(tp,aux.Stringid(17060857,3))
end
function c17060857.repval(e,c)
	return c17060857.repfilter(c,e:GetHandlerPlayer())
end
function c17060857.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end