--搭档型剑城＆菲
function c17060863.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c17060863.xyzfilter,5,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--special summon ＆ pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060863,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060863)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c17060863.sptg)
	e1:SetOperation(c17060863.spop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060863,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c17060863.pencon)
	e2:SetTarget(c17060863.pentg)
	e2:SetOperation(c17060863.penop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c17060863.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060863,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_CONFIRM)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c17060863.atkcon)
	e4:SetCost(c17060863.atkcost)
	e4:SetOperation(c17060863.atkop)
	c:RegisterEffect(e4)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17060863,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,170608631)
	e5:SetTarget(c17060863.pentg1)
	e5:SetOperation(c17060863.penop1)
	c:RegisterEffect(e5)
end
c17060863.pendulum_level=5
c17060863.is_named_with_Partner=1
c17060863.is_named_with_Fencing=1
c17060863.is_named_with_Million_Arthur=1
function c17060863.IsPartner(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Partner
end
function c17060863.IsFencing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Fencing
end
function c17060863.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060863.xyzfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_PENDULUM)
end
function c17060863.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060863.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060863.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060863.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c17060863.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060863.mfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c17060863.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local g=Duel.GetMatchingGroup(c17060863.mfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(17060863,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=g:Select(tp,1,1,nil)
				if mg:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then return end
				Duel.Overlay(e:GetHandler(),mg)
			end
		end
	end
end
function c17060863.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c17060863.chkfilter(c)
	return c17060863.IsFencing(c)
end
function c17060863.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c17060863.chkfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c17060863.pfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17060863.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	and Duel.IsExistingMatchingCard(c17060863.pfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c17060863.penop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c17060863.pfilter,tp,LOCATION_EXTRA,0,1,ct,nil)
	local pc=g:GetFirst()
	while pc do
		Duel.MoveToField(pc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		pc:RegisterEffect(e1)
		pc=g:GetNext()
	end
end
function c17060863.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17060863.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c17060863.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local val=g:GetSum(Card.GetRank)*200
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c17060863.penfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060863.pentg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060863.penfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c17060863.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17060863.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17060863.penop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end