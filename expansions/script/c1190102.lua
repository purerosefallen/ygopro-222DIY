--ELF·妖精公主
function c1190102.initial_effect(c)
--
	aux.AddSynchroProcedure(c,c1190102.syfilter1,c1190102.syfilter2,1)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1190102)
	e1:SetCondition(c1190102.con1)
	e1:SetTarget(c1190102.tg1)
	e1:SetOperation(c1190102.op1)
	c:RegisterEffect(e1) 
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1190152)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c1190102.con2)
	e2:SetTarget(c1190102.tg2)
	e2:SetOperation(c1190102.op2)
	c:RegisterEffect(e2)	   
end
--
c1190102.named_with_ELF=1
function c1190102.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190102.syfilter1(c)
	return c1190102.IsELF(c) and c:IsType(TYPE_TUNER)
end
function c1190102.syfilter2(c)
	return c1190102.IsELF(c) and c:IsType(TYPE_MONSTER)
end
--
function c1190102.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
--
function c1190102.filter1(c,e,tp)
	return c1190102.IsELF(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1190102.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c1190102.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c1190102.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1190102.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
--
function c1190102.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.Damage(1-tp,400,REASON_EFFECT)
end
--
--
function c1190102.con2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and Duel.IsChainNegatable(ev)
end
function c1190102.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c1190102.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetTargetRange(0,LOCATION_DECK)
	Duel.RegisterEffect(e2,tp)
end
