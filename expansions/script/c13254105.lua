--扭曲飞球·心魔降临
function c13254105.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c13254105.ffilter1,aux.FilterBoolFunction(c13254105.ffilter2,c),2,2,true)
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
	e2:SetCondition(c13254105.sprcon)
	e2:SetOperation(c13254105.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c13254105.sptg)
	e3:SetOperation(c13254105.spop)
	c:RegisterEffect(e3)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e5)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e14)
	local e15=e13:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e15)
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCode(EVENT_ADJUST)
	e16:SetCondition(c13254105.anticon)
	e16:SetOperation(c13254105.anticopy)
	c:RegisterEffect(e16)
	
end
function c13254105.ffilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH)
end
function c13254105.ffilter2(c,fc)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsControler(fc:GetControler())
end
function c13254105.cfilter(c,tp)
	return (c:IsFusionAttribute(ATTRIBUTE_EARTH) or (c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsControler(tp)) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c13254105.fcheck(c,sg,tp)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and sg:IsExists(c13254105.fcheck2,2,c,tp)
end
function c13254105.fcheck2(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsControler(tp)
end
function c13254105.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c13254105.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254105.fcheck,1,nil,sg,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c13254105.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254105.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254105.fselect,1,nil,tp,mg,sg)
end
function c13254105.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254105.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=mg:FilterSelect(tp,c13254105.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_COST)
end
function c13254105.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=1-(Duel.GetTurnPlayer())
	if chk==0 then return Duel.GetLocationCount(p,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c13254105.spfilter,p,LOCATION_GRAVE,0,1,nil,e,p) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c13254105.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=1-(Duel.GetTurnPlayer())
	local sg=Duel.GetMatchingGroup(c13254105.spfilter,p,LOCATION_GRAVE,0,nil,e,p)
	if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and sg:GetCount()>0 then
		local tc=sg:Select(p,1,1,nil)
		Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function c13254105.anticon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c13254105.anticopy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c13254105.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
	Duel.SendtoGrave(c,REASON_RULE)
end
function c13254105.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
