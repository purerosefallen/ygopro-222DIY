--半 分 虚 幻 的 庭 师
local m=46564044
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--Race Zomble
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_RACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e6)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(cm.cost)
	e7:SetTarget(cm.target)
	e7:SetOperation(cm.operation)
	c:RegisterEffect(e7)  
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function cm.spfilter1(c,fc)
	return c:IsRace(RACE_WARRIOR) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function cm.spfilter2(c,fc)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,c) and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE,0,1,nil,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g1:Merge(g2)
	if g1:GetCount()>1 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
