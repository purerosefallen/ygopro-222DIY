--ＬＰＭ 波尔凯尼恩
function c80000462.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c80000462.ffilter1,c80000462.ffilter2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80000462.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c80000462.spcon)
	e2:SetOperation(c80000462.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--Attribute Dark
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_RACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
	e4:SetValue(RACE_PYRO)
	c:RegisterEffect(e4)
	--Attribute Dark
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ADD_ATTRIBUTE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
	e5:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e5)
	--Eraser
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(57793869,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c80000462.erascon)
	e6:SetTarget(c80000462.erastg)
	e6:SetOperation(c80000462.erasop)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c80000462.efilter)
	c:RegisterEffect(e7)
	--atkup
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetValue(c80000462.value)
	c:RegisterEffect(e8)
	--atkchange
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SET_ATTACK)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,LOCATION_MZONE)
	e9:SetTarget(c80000462.atfilter)
	c:RegisterEffect(e9)
	--atkchange
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SET_DEFENSE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(0,LOCATION_MZONE)
	e10:SetTarget(c80000462.atfilter)
	c:RegisterEffect(e10)
	--disable
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(0,LOCATION_MZONE)
	e11:SetTarget(c80000462.distg)
	c:RegisterEffect(e11)
end
function c80000462.distg(e,c)
	return c:IsRace(RACE_AQUA+RACE_PYRO) or c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_FIRE)
end
function c80000462.atfilter(e,c)
	return c:IsRace(RACE_AQUA+RACE_PYRO) or c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_FIRE)
end
function c80000462.filter(c)
	return c:IsFaceup() and (c:IsRace(RACE_AQUA+RACE_PYRO) or c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_FIRE))
end
function c80000462.value(e,c)
	return Duel.GetMatchingGroupCount(c80000462.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function c80000462.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000462.ffilter1(c)
	return c:IsSetCard(0x2d0) and c:IsFusionAttribute(ATTRIBUTE_FIRE) and c:GetLevel()==8
end
function c80000462.ffilter2(c)
	return c:IsSetCard(0x2d0) and c:IsFusionAttribute(ATTRIBUTE_WATER) and c:GetLevel()==8
end
function c80000462.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80000462.spfilter1(c,tp,fc)
	return c:IsSetCard(0x2d0) and c:IsFusionAttribute(ATTRIBUTE_FIRE) and c:GetLevel()==8 and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c80000462.spfilter2,1,c,fc)
end
function c80000462.spfilter2(c,fc)
	return c:IsSetCard(0x2d0) and c:IsFusionAttribute(ATTRIBUTE_WATER) and c:GetLevel()==8 and c:IsCanBeFusionMaterial(fc)
end
function c80000462.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c80000462.spfilter1,1,nil,tp,c)
end
function c80000462.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c80000462.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c80000462.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c80000462.erascon(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c80000462.erastg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c80000462.erasop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end