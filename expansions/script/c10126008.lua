--神匠神 破刃
function c10126008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)   
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10126008.sprcon)
	e2:SetOperation(c10126008.sprop)
	c:RegisterEffect(e2)   
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetCondition(c10126008.con1)
	c:RegisterEffect(e3) 
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	e4:SetCondition(c10126008.con2)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c10126008.efilter)
	e5:SetCondition(c10126008.con3)
	c:RegisterEffect(e5)
end
function c10126008.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c10126008.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c10126004.confilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp)>=4
end
function c10126008.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c10126004.confilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp)>=3
end
function c10126008.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c10126004.confilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp)>=2
end
function c10126004.confilter(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp) 
end
function c10126008.spfilter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
end
function c10126008.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10126008.spfilter1,tp,LOCATION_MZONE,0,2,nil)
end
function c10126008.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10126008.spfilter1,tp,LOCATION_MZONE,0,2,2,nil)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end