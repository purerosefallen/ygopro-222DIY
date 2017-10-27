--感谢姬
function c17060828.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060828,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060828.sccon)
	e1:SetTarget(c17060828.sctg)
	e1:SetOperation(c17060828.scop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060828,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c17060828.sptg)
	e2:SetOperation(c17060828.spop)
	c:RegisterEffect(e2)
	--Banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060828,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(LOCATION_REMOVED)
	e3:SetCondition(c17060828.rmcon)
	c:RegisterEffect(e3)
end
c17060828.is_named_with_Million_Arthur=1
function c17060828.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060828.cfilter(c)
	return c17060828.IsMillion_Arthur(c)
end
function c17060828.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17060826.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c17060828.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLeftScale()~=7 end
end
function c17060828.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetLeftScale()==7 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(9)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
end
function c17060828.spfilter(c,e,tp)
	return c17060828.IsMillion_Arthur(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060828.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c17060828.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c17060828.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060828.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c17060828.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end