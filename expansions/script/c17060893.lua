--暗堕狼娘
function c17060893.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,17060854,c17060893.ffilter,1,true,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(17060893,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c17060893.fpcon)
	e0:SetOperation(c17060893.fpop)
	c:RegisterEffect(e0)
	--pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060893,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,17060893)
	e1:SetCondition(c17060893.pspcon)
	e1:SetTarget(c17060893.psptg)
	e1:SetOperation(c17060893.pspop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c17060893.pspcon1)
	c:RegisterEffect(e2)
	--SP Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060893,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c17060893.sptg)
	e3:SetOperation(c17060893.spop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060893,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c17060893.reptg)
	e4:SetValue(c17060893.repval)
	e4:SetOperation(c17060893.repop)
	c:RegisterEffect(e4)
	--spsummon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c17060893.splimit)
	c:RegisterEffect(e5)
end
c17060893.is_named_with_Dark_Degenerate=1
function c17060893.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060893.ffilter(c,fc)
	return c17060893.IsDark_Degenerate(c) and c:IsCanBeFusionMaterial(fc)
end
function c17060893.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c17060893.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060893.pspcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterEqualFunction(Card.GetSummonLocation,LOCATION_EXTRA),tp,0,LOCATION_MZONE,1,nil)
end
function c17060893.rfilter(c,fc)
	return (c:IsCode(17060854) or c17060893.IsDark_Degenerate(c))
		and c:IsCanBeFusionMaterial(fc)
end
function c17060893.spfilter1(c,tp,g)
	return g:IsExists(c17060893.spfilter2,1,c,tp,c)
end
function c17060893.spfilter2(c,tp,mc)
	return (c:IsCode(17060854) and c17060893.IsDark_Degenerate(mc)
		or c17060893.IsDark_Degenerate(c) and mc:IsCode(17060854))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c17060893.fpcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c17060893.rfilter,nil,c)
	return rg:IsExists(c17060893.spfilter1,1,nil,tp,rg)
end
function c17060893.fpop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c17060893.rfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=rg:FilterSelect(tp,c17060893.spfilter1,1,1,nil,tp,rg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=rg:FilterSelect(tp,c17060893.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c17060893.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c17060893.IsDark_Degenerate(c)
end
function c17060893.psptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c17060893.pcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060893.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c17060893.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060893.pspop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c17060893.penfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060893.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c17060893.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c17060893.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17060893.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c17060893.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c17060893.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c17060893.repfilter,1,nil,tp)
	and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	return Duel.SelectYesNo(tp,aux.Stringid(17060893,4))
end
function c17060893.repval(e,c)
	return c17060893.repfilter(c,e:GetHandlerPlayer())
end
function c17060893.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end