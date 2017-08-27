--地狱死星 死神 德莱弗斯
function c10129011.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),3,false)  
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10129011.splimit)
	c:RegisterEffect(e0) 
	--Release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10129011,0))
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10129011.recon)
	e2:SetTarget(c10129011.retg)
	e2:SetOperation(c10129011.reop)
	c:RegisterEffect(e2)   
	--summmoncost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetTarget(c10129011.sumtg)
	e3:SetCondition(c10129011.sumcon)
	e3:SetOperation(c10129011.sumop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c10129011.atkval)
	c:RegisterEffect(e5)
end
function c10129011.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10129011.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*800
end
function c10129011.atkfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsFaceup()
end
function c10129011.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(Duel.GetTurnPlayer(),ACTIVITY_SUMMON)+Duel.GetActivityCount(Duel.GetTurnPlayer(),ACTIVITY_SPSUMMON)>=2
end
function c10129011.sumtg(e,c)
	return c:GetSummonPlayer()==Duel.GetTurnPlayer()
end
function c10129011.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10129011.recon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c10129011.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
end
function c10129011.reop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckReleaseGroup(1-tp,nil,1,nil) then return end
	local g1=Duel.SelectReleaseGroup(1-tp,nil,1,1,nil)
	Duel.Release(g1,REASON_RULE)
end
function c10129011.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+101
end