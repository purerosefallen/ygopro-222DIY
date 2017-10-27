--宵月魔瑟
function c17060906.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c17060906.matfilter),1)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--ep effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060906,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060906.epcon)
	e1:SetTarget(c17060906.eptg)
	e1:SetOperation(c17060906.epop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060906,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c17060906.spcon)
	e2:SetTarget(c17060906.sptg)
	e2:SetOperation(c17060906.spop)
	c:RegisterEffect(e2)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c17060906.atktg)
	e3:SetOperation(c17060906.atkop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060906,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c17060906.pencon)
	e4:SetTarget(c17060906.pentg)
	e4:SetOperation(c17060906.penop)
	c:RegisterEffect(e4)
end
c17060906.is_named_with_Magic_Factions=1
c17060906.is_named_with_Million_Arthur=1
function c17060906.IsMagic_Factions(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Magic_Factions
end
function c17060906.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060906.matfilter(c)
	return c17060906.IsMillion_Arthur(c)
end
function c17060906.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c17060906.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c17060906.eptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c17060906.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060906.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c17060906.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c17060906.epop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.GetControl(tc,1-tp,nil,1)
	end
end
function c17060906.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) or e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c17060906.spfilter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c17060906.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c17060906.spfilter,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c17060906.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060906.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17060906.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_PZONE,0,1,1,nil)
end
function c17060906.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
		local bc=g:GetFirst()
		local atk=tc:GetLeftScale()
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(math.ceil(atk*100))
		e3:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e3)
	end
end
function c17060906.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060906.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1) end
end
function c17060906.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(1-tp,LOCATION_PZONE,0) and not Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
