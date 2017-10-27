--叛逆的魔女 晓美焰
function c60151016.initial_effect(c)
	c:SetUniqueOnField(1,1,60151016)
	c:EnableReviveLimit()
	--spsummon condition
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e11)
	--special summon rule
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(60151016,1))
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_EXTRA)
	e12:SetValue(1)
	e12:SetCondition(c60151016.sprcon)
	e12:SetOperation(c60151016.sprop)
	c:RegisterEffect(e12)
	--disable and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(c60151016.condition)
	e1:SetOperation(c60151016.disop)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151016,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60151016.discon)
	e3:SetCost(c60151016.discost)
	e3:SetTarget(c60151016.distg)
	e3:SetOperation(c60151016.disop2)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(c60151016.immcon)
	e5:SetValue(c60151016.efilter)
	c:RegisterEffect(e5)
end
function c60151016.spfilter1(c)
	return c:IsSetCard(0x5b23) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial()
end
function c60151016.spfilter2(c)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_XYZ) and c:IsCanBeFusionMaterial()
end
function c60151016.spfilter3(c)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_FUSION) and c:IsCanBeFusionMaterial()
end
function c60151016.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>-2
		and Duel.IsExistingMatchingCard(c60151016.spfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c60151016.spfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c60151016.spfilter3,tp,LOCATION_MZONE,0,1,nil)
end
function c60151016.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151016,2))
	local g1=Duel.SelectMatchingCard(tp,c60151016.spfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151016,3))
	local g2=Duel.SelectMatchingCard(tp,c60151016.spfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151016,4))
	local g3=Duel.SelectMatchingCard(tp,c60151016.spfilter3,tp,LOCATION_MZONE,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c60151016.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function c60151016.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local rc=re:GetHandler()
	Duel.NegateEffect(ev)
end
function c60151016.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and tp~=ep
end
function c60151016.cfilter(c)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c60151016.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151016.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60151016.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60151016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c60151016.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c60151016.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<2
end
function c60151016.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:IsHasType(EFFECT_TYPE_ACTIVATE) then return true end
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then return true end
end