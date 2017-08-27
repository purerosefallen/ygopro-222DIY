--超古代口袋妖怪 固拉多
function c80000145.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c80000145.ffilter,5,true)
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000145.efilter)
	c:RegisterEffect(e8) 
	--spsummon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c80000145.splimit)
	c:RegisterEffect(e5)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ENVIRONMENT)
	e1:SetValue(80000147)
	c:RegisterEffect(e1)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c80000145.destg)
	e6:SetOperation(c80000145.desop)
	c:RegisterEffect(e6)
	--pos Change
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000145,0))
	e7:SetCategory(CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(TIMING_BATTLE_START,TIMING_BATTLE_START)
	e7:SetCondition(c80000145.negcon)
	e7:SetCountLimit(1)
	e7:SetOperation(c80000145.posop)
	c:RegisterEffect(e7)
	--dis field
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(80000145,1))
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_BATTLE_DESTROYING)
	e10:SetOperation(c80000145.operation)
	c:RegisterEffect(e10)
end
function c80000145.negcon(e,tp,eg,ep,ev,re,r,rp)
	 return  Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckPhaseActivity() and Duel.GetCurrentChain()==0
end
function c80000145.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	--disable field
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c80000145.disop)
	e:GetHandler():RegisterEffect(e1)
end
function c80000145.disop(e,tp)
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	return dis1
end
function c80000145.filter222(c)
	return c:IsFaceup() and not c:IsCode(80000145)
end
function c80000145.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000145.filter222,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end
function c80000145.ffilter(c)
	return  c:IsSetCard(0x2d0) and c:IsType(TYPE_SYNCHRO)
end
function c80000145.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000145.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80000145.filter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80000145.desfilter1(c)
	return (c:IsFacedown() or not c:IsCode(80000147))  and c:IsType(TYPE_FIELD) and c:IsAbleToRemove()
end
function c80000145.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000145.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c80000145.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c80000145.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000145.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end