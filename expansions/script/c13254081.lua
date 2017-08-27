--灵魂飞球
function c13254081.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,13254053,aux.FilterBoolFunction(c13254081.ffilter),1,true,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c13254081.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c13254081.sprcon)
	e2:SetOperation(c13254081.sprop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254081,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,13254081)
	e3:SetTarget(c13254081.sptg)
	e3:SetOperation(c13254081.spop)
	c:RegisterEffect(e3)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CHANGE_CODE)
	e11:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e11:SetValue(13254037)
	c:RegisterEffect(e11)
	
end
function c13254081.ffilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c13254081.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c13254081.cfilter(c)
	return (c:IsFusionCode(13254053) or (c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFusionAttribute(ATTRIBUTE_DARK)) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost()
end
function c13254081.fcheck(c,sg)
	return c:IsFusionCode(13254053) and sg:IsExists(c13254081.fcheck2,1,c)
end
function c13254081.fcheck2(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c13254081.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c13254081.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254081.fcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c13254081.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254081.cfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254081.fselect,1,nil,tp,mg,sg)
end
function c13254081.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254081.cfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c13254081.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c13254081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsLocation(LOCATION_MZONE) and c:IsAbleToGrave()) end
end
function c13254081.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		--cannot release
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e11:SetRange(LOCATION_MZONE)
		e11:SetCode(EFFECT_UNRELEASABLE_SUM)
		e11:SetValue(1)
		e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e11)
		local e12=e11:Clone()
		e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e12)
		local e13=Effect.CreateEffect(e:GetHandler())
		e13:SetType(EFFECT_TYPE_SINGLE)
		e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e13:SetValue(1)
		e13:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e13)
		local e14=e13:Clone()
		e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		c:RegisterEffect(e14)
		local e15=e13:Clone()
		e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e15)
		local e16=Effect.CreateEffect(e:GetHandler())
		e16:SetDescription(aux.Stringid(13254081,3))
		e16:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e16:SetType(EFFECT_TYPE_SINGLE)
		e16:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e16)
	elseif c:IsLocation(LOCATION_MZONE) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
