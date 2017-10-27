--暗堕型歌姬亚瑟
function c17060822.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ep effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060822,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060822.epcon)
	e1:SetTarget(c17060822.eptg)
	e1:SetOperation(c17060822.epop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060822,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,17060822)
	e2:SetCost(c17060822.spcost)
	e2:SetTarget(c17060822.sptg1)
	e2:SetOperation(c17060822.spop1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060822,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,170608221)
	e3:SetTarget(c17060822.sptg)
	e3:SetOperation(c17060822.spop)
	c:RegisterEffect(e3)
end
c17060822.is_named_with_Singer_Arthur=1
c17060822.is_named_with_Million_Arthur=1
c17060822.is_named_with_Dark_Degenerate=1
function c17060822.IsSinger_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Singer_Arthur
end
function c17060822.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060822.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060822.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c17060822.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c17060822.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c17060822.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_PENDULUM) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_PENDULUM)
	Duel.Release(g,REASON_COST)
end
function c17060822.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17060822.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17060822.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c17060822.splimit(e,c)
	return not c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end

function c17060822.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060822.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c17060822.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c17060822.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17060822.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17060822.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end