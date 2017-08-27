--蹦跳 星空一跃
function c197520011.initial_effect(c)
	c:SetSPSummonOnce(197520011)
	c:EnableReviveLimit()  
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c197520011.efilter)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(197520011,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c197520011.thcost)
	e2:SetTarget(c197520011.target)
	e2:SetOperation(c197520011.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c197520011.discon)
	e3:SetTarget(c197520011.distg)
	e3:SetOperation(c197520011.disop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(197520011,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCost(c197520011.thcost1)
	e4:SetCondition(c197520011.condition)
	e4:SetTarget(c197520011.target1)
	e4:SetOperation(c197520011.operation1)
	c:RegisterEffect(e4)
end
function c197520011.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c197520011.thfilter(c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c197520011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c197520011.thfilter,tp,LOCATION_GRAVE,0,5,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c197520011.thfilter,tp,LOCATION_GRAVE,0,5,5,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c197520011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c197520011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c197520011.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c197520011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c197520011.disop(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c197520011.aclimit)
		e1:SetLabel(code)
		e1:SetReset(0x1fe1000)
		e:GetHandler():RegisterEffect(e1,true)
	end
end
function c197520011.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c197520011.thfilter1(c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) 
end
function c197520011.thfilter2(c)
	return c:IsCode(197520002) and c:IsType(TYPE_MONSTER) 
end
function c197520011.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c197520011.thfilter1,4,nil) end
	local g=Duel.SelectReleaseGroup(tp,c197520011.thfilter1,4,4,nil)
	Duel.Release(g,REASON_COST)
end
function c197520011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c197520011.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c197520011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c197520011.thfilter2,tp,LOCATION_MZONE,0,1,nil)
end