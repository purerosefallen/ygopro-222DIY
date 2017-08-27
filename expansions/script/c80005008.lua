--命运女神 圣灵之梦
function c80005008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c80005008.ffilter,c80005008.ffilter1,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c80005008.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c80005008.spcon)
	e2:SetOperation(c80005008.spop)
	c:RegisterEffect(e2)
	--cannot be fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c80005008.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5) 
	--Attribute Dark
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e6) 
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80005008,3))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,80005008)
	e7:SetCost(c80005008.atkcost)
	e7:SetTarget(c80005008.tttt)
	e7:SetOperation(c80005008.atkop)
	c:RegisterEffect(e7)
end
function c80005008.ffilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:GetTextAttack()==-2 and c:GetTextDefense()==-2 
end
function c80005008.ffilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:GetTextAttack()==-2 and c:GetTextDefense()==-2 
end
function c80005008.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c80005008.spfilter1(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetTextAttack()==-2 and c:GetTextDefense()==-2 and c:IsCanBeFusionMaterial() and Duel.CheckReleaseGroup(tp,c80005008.spfilter2,1,c) 
end
function c80005008.spfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:GetTextAttack()==-2 and c:GetTextDefense()==-2 and c:IsCanBeFusionMaterial() 
end
function c80005008.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c80005008.spfilter1,1,nil,tp)
end
function c80005008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c80005008.spfilter1,1,1,nil,tp)
	local g2=Duel.SelectReleaseGroup(tp,c80005008.spfilter2,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c80005008.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*400
end
function c80005008.tttt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c80005008.atkop(e,tp,eg,ep,ev,re,r,rp)
	g=Duel.GetDecktopGroup(1-tp,1)
	hg=Duel.GetDecktopGroup(tp,1)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)
end
function c80005008.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80005008.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c80005008.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c80005008.cfilter(c,e,tp)
	return c:IsReleasable()
end