--静止的光景
local m=50000077
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.datg)
	e1:SetOperation(cm.daop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
end
function cm.dafilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsSetCard(0x50c) and not c:IsDualState()
end
function cm.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.dafilter(chkc) end
	if chk==0 then return  Duel.IsExistingTarget(cm.dafilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.dafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and cm.dafilter(tc) then
		tc:EnableDualState()
	end
end
--
function cm.spcfilter(c)
	return c:IsSetCard(0x50c)  and c:IsAbleToRemoveAsCost() and c:GetLevel()>0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_GRAVE,0,e:GetHandler()) 
	if chk==0 then return rg:CheckWithSumEqual(Card.GetLevel,8,1,rg:GetCount()) and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rm=rg:SelectWithSumEqual(tp,Card.GetLevel,8,1,rg:GetCount())
	Duel.Remove(rm,POS_FACEUP,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return  c:IsSetCard(0x50c) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.filter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)*300
end
function cm.filter(c)
	return c:IsSetCard(0x50c) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end