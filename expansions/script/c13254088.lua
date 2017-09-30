--扭曲飞球·咒流
function c13254088.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--aux.AddFusionProcFunFunRep(c,c13254088.ffilter1,aux.FilterBoolFunction(c13254088.ffilter2,c),2,2,true)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c13254088.fscon)
	e1:SetOperation(c13254088.fsop)
	c:RegisterEffect(e1)
	--spsummon condition
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,13254088)
	e2:SetCondition(c13254088.sprcon)
	e2:SetOperation(c13254088.sprop)
	c:RegisterEffect(e2)
	--disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e5)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_CHANGE_LEVEL)
	e10:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCode(EVENT_ADJUST)
	e16:SetCondition(c13254088.anticon)
	e16:SetOperation(c13254088.anticopy)
	c:RegisterEffect(e16)
	
end
function c13254088.ffilter1(c,fc,sg,tp)
	local g=sg:Filter(c13254088.ffilter2,c,fc,tp)
	return c:IsType(TYPE_EFFECT) and c:IsCanBeFusionMaterial(fc) and g:CheckWithSumGreater(Card.GetOriginalLevel,4)
end
function c13254088.ffilter2(c,fc,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsCanBeFusionMaterial(fc) and c:GetOriginalLevel()>=1 and c:IsControler(tp)
end
function c13254088.CheckRecursive(c,fc,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c13254088.CheckRecursive,1,sg,fc,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254088.ffilter1,1,nil,fc,sg,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c13254088.CheckRecursive1(c,fc,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c13254088.CheckRecursive1,1,sg,fc,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=c13254088.ffilter2(c,fc,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c13254088.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	local fs=false
	if not g:IsExists(c13254088.ffilter1,1,nil,e:GetHandler(),g,chkf) then return false end
	local mg=g:Filter(c13254088.ffilter,nil,e:GetHandler(),chkf)
	return mg:IsExists(c13254088.CheckRecursive,1,sg,e:GetHandler(),chkf,mg,sg)
end
function c13254088.ffilter(c,fc,tp)
	return (c:IsFusionType(TYPE_EFFECT) or c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:GetOriginalLevel()>=1 and c:IsControler(fc:GetControler())) and c:IsCanBeFusionMaterial(fc)
end
function c13254088.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local sg=Group.CreateGroup()
	local g=Group.CreateGroup()
	local lvsum=0
	local c=e:GetHandler()
	local i=0
	if gc then sg:AddCard(gc) end
	local mg=eg:Filter(c13254088.ffilter,nil,e:GetHandler(),chkf)
	repeat
		if i==0 and mg:IsExists(c13254088.CheckRecursive,1,sg,e:GetHandler(),chkf,mg,sg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g=mg:FilterSelect(tp,c13254088.CheckRecursive,1,1,sg,e:GetHandler(),chkf,mg,sg)
		elseif mg:IsExists(c13254088.CheckRecursive1,1,sg,e:GetHandler(),chkf,mg,sg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g=mg:FilterSelect(tp,c13254088.CheckRecursive1,1,1,sg,e:GetHandler(),chkf,mg,sg)
		else break
		end
		if c13254088.ffilter2(g:GetFirst(),e:GetHandler(),chkf) then
			lvsum=lvsum+g:GetFirst():GetOriginalLevel()
		else i=1
		end
		sg:Merge(g)
		if not (i==0 and mg:IsExists(c13254088.CheckRecursive,1,sg,e:GetHandler(),chkf,mg,sg)) and not mg:IsExists(c13254088.CheckRecursive1,1,sg,e:GetHandler(),chkf,mg,sg) then break end
	until sg:IsExists(c13254088.ffilter1,1,nil,e:GetHandler(),sg,chkf) and not Duel.SelectYesNo(tp,210)
	Duel.SetFusionMaterial(sg)
end
function c13254088.fcheck(c,sg,tp)
	return c:IsFusionType(TYPE_EFFECT) and c:IsFaceup() and sg:IsExists(c13254088.fcheck2,2,c,tp)
end
function c13254088.fcheck2(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and c:IsFusionType(TYPE_FUSION) and c:IsControler(tp)
end
function c13254088.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c13254088.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c13254088.fcheck,1,nil,sg,tp)
	end
	sg:RemoveCard(c)
	return res
end
function c13254088.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13254088.ffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c13254088.CheckRecursive,1,nil,c,tp,mg,sg)
end
function c13254088.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13254088.ffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	local g=Group.CreateGroup()
	local i=0
	local lvsum=0
	repeat
		if i==0 and mg:IsExists(c13254088.CheckRecursive,1,sg,c,tp,mg,sg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g=mg:FilterSelect(tp,c13254088.CheckRecursive,1,1,sg,c,tp,mg,sg)
		elseif mg:IsExists(c13254088.CheckRecursive1,1,sg,c,tp,mg,sg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g=mg:FilterSelect(tp,c13254088.CheckRecursive1,1,1,sg,c,tp,mg,sg)
		else break
		end
		if c13254088.ffilter2(g:GetFirst(),c,tp) then
			lvsum=lvsum+g:GetFirst():GetOriginalLevel()
		else i=1
		end
		sg:Merge(g)
		if not (i==0 and mg:IsExists(c13254088.CheckRecursive,1,sg,c,tp,mg,sg)) and not mg:IsExists(c13254088.CheckRecursive1,1,sg,c,tp,mg,sg) then break end
	until sg:IsExists(c13254088.ffilter1,1,nil,c,sg,tp) and not Duel.SelectYesNo(tp,210)
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.Release(sg,REASON_COST)
end
function c13254088.anticon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetControler()~=c:GetOwner()
end
function c13254088.anticopy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c13254088.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
	Duel.SendtoGrave(c,REASON_RULE)
end
function c13254088.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
