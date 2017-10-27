--剑城
function c17060843.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,3,c17060843.ovfilter,aux.Stringid(17060843,0))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060843,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17060843)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c17060843.tgcost)
	e1:SetTarget(c17060843.tgtg)
	e1:SetOperation(c17060843.tgop)
	c:RegisterEffect(e1)
	--XYZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060843,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCondition(c17060843.xyzcon)
	e2:SetCost(c17060843.xyzcost)
	e2:SetTarget(c17060843.xyztg)
	e2:SetOperation(c17060843.xyzop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060843,3))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c17060843.atkcost)
	e3:SetOperation(c17060843.atkop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060843,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c17060843.pencon)
	e4:SetTarget(c17060843.pentg)
	e4:SetOperation(c17060843.penop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
c17060843.pendulum_level=4
c17060843.is_named_with_Fencing=1
c17060843.is_named_with_Million_Arthur=1
function c17060843.IsFencing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Fencing
end
function c17060843.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060843.ovfilter(c)
	return c:IsFaceup() and c:IsCode(17060805) and c:GetOverlayCount()==0
end
function c17060843.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c17060843.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c17060843.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c17060843.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsSummonType(SUMMON_TYPE_XYZ) and tc:IsControler(1-tp)
end
function c17060843.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(17060843)==0 end
	c:RegisterFlagEffect(17060843,RESET_CHAIN,0,1)
end
function c17060843.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsXyzSummonable(nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function c17060843.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(17060843,5)) then
		Duel.XyzSummon(tp,e:GetHandler(),nil)
	end
end
function c17060843.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17060843.atkfilter(c)
	return c:IsFaceup() and c17060843.IsMillion_Arthur(c)
end
function c17060843.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c17060843.atkfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetValue(ct*400)
		tc:RegisterEffect(e3)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
end
function c17060843.filter(c,e,tp)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060843.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060843.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c17060843.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17060843.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(17060843,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,c17060843.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end