--王位壕
function c17060831.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c17060831.ffilter1,c17060831.ffilter2,true)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon(PZONE)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(17060831,1))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,17060831)
	e0:SetCondition(c17060831.spcon)
	e0:SetTarget(c17060831.sptg)
	e0:SetOperation(c17060831.spop1)
	c:RegisterEffect(e0)
	--spsummon(MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060831,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17060831+100)
	e1:SetCondition(c17060831.spcon)
	e1:SetTarget(c17060831.sptg)
	e1:SetOperation(c17060831.spop)
	c:RegisterEffect(e1)
	--pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060831,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c17060831.pencon)
	e2:SetTarget(c17060831.pentg)
	e2:SetOperation(c17060831.penop)
	c:RegisterEffect(e2)
end
c17060831.is_named_with_Regal_Arthur=1
c17060831.is_named_with_Million_Arthur=1
function c17060831.IsRegal_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Regal_Arthur
end
function c17060831.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060831.ffilter1(c)
	return c17060831.IsRegal_Arthur(c)
end
function c17060831.ffilter2(c)
	return c17060831.IsMillion_Arthur(c)
end
function c17060831.cfilter(c,tp)
	return c:IsFaceup() and c17060831.IsMillion_Arthur(c) and c:IsControler(tp)
end
function c17060831.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c17060831.cfilter,1,nil,tp)
end
function c17060831.spfilter(c,e,tp)
	return c17060831.IsMillion_Arthur(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060831.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c17060831.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c17060831.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17060831.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17060831.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17060831.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17060831.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060831.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17060831.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
