--超古代口袋妖怪 盖欧卡
function c80000146.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c80000146.ffilter,5,true)
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000146.efilter)
	c:RegisterEffect(e8)   
	--spsummon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c80000146.splimit)
	c:RegisterEffect(e5)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ENVIRONMENT)
	e1:SetValue(80000148)
	c:RegisterEffect(e1)
	--Activate
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetCountLimit(1)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c80000146.condition)
	e9:SetCost(c80000146.cost)
	e9:SetTarget(c80000146.target)
	e9:SetOperation(c80000146.activate)
	c:RegisterEffect(e9)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c80000146.destg)
	e6:SetOperation(c80000146.desop)
	c:RegisterEffect(e6)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(c80000146.disop)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c80000146.atktarget)
	c:RegisterEffect(e3)
end
function c80000146.atktarget(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c80000146.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if not re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and loc==LOCATION_GRAVE or loc==LOCATION_REMOVED then
		Duel.NegateEffect(ev)
	end
end
function c80000146.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80000146.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c80000146.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsType(TYPE_XYZ)
end
function c80000146.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000146.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80000146.filter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80000146.desfilter1(c)
	return (c:IsFacedown() or not c:IsCode(80000148))  and c:IsType(TYPE_FIELD) and c:IsAbleToRemove()
end
function c80000146.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000146.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c80000146.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c80000146.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000146.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c80000146.desfilter(c)
	return  c:IsDestructable()
end
function c80000146.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c80000146.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000146.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c80000146.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c80000146.chainlimit)
end
function c80000146.chainlimit(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80000146.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80000146.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c80000146.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c80000146.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c80000146.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c80000146.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c80000146.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
