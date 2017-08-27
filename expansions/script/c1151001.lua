--永远鲜红的幼月
function c1151001.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c1151001.con0)
	e0:SetOperation(c1151001.op0)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1151001,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1151001)
	e1:SetCondition(c1151001.con1)
	e1:SetTarget(c1151001.tg1)
	e1:SetOperation(c1151001.op1)
	c:RegisterEffect(e1)
	local e1_1=e1:Clone()
	e1_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1_1)
--
end
--
c1151001.named_with_Leimi=1
function c1151001.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151001.IsLeisp(c)
	return c.named_with_Leisp
end
--
function c1151001.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c1151001.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function c1151001.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(c1151001.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function c1151001.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then
		sg:Merge(cg)
	end
	local ct=sg:GetCount()
	local ag=g:Filter(c1151001.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)	
	while ct<max and ag:GetCount()>0 do
		local minc=1
		local finish=(ct>=min and f(sg,...))
		if finish then minc=0 end
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=ag:Select(tp,minc,1,nil)
		if tg:GetCount()==0 then break end
		sg:Merge(tg)
		ct=sg:GetCount()
		ag=g:Filter(c1151001.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
	end
	return sg
end
--
function c1151001.cfilter0_1(c, syncard)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else 
		return c:GetSynchroLevel(syncard)
	end
end
--
function c1151001.goal(g,tp,syncard)
	local ct=g:GetCount()
	return g:CheckWithSumEqual(c1151001.cfilter0_1,syncard:GetLevel(),ct,ct,syncard) and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
--
function c1151001.cfilter0(c,tp,mg,turner,e)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false) and c1151001.CheckGroup(mg,c1151001.goal,Group.FromCards(turner),2,63,tp,c)
end
--
function c1151001.con0(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1151001.ofilter0,tp,LOCATION_MZONE,0,c)
	return Duel.IsExistingMatchingCard(c1151001.cfilter0,tp,LOCATION_EXTRA,0,1,nil,tp,mg,c,e)
end
--
function c1151001.ofilter0(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c1151001.op0(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c1151001.ofilter0,tp,LOCATION_MZONE,0,c)
	local syncG=Duel.SelectMatchingCard(tp,c1151001.cfilter0,tp,LOCATION_EXTRA,0,1,1,nil,tp,g,c,e)
	if syncG:GetCount()<1 then return end
	sg:Merge(syncG)
	local sync=syncG:GetFirst()
	local mg=c1151001.SelectGroup(tp,HINTMSG_TOGRAVE,g,c1151001.goal,Group.FromCards(c),2,63,tp,sync)
	sync:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_SYNCHRO)
	sync:CompleteProcedure()
end
--
function c1151001.cfilter1(c,e,tp)
	return c:IsFaceup()
end
function c1151001.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1151001.cfilter1,1,e:GetHandler(),e,tp)
end 
--
function c1151001.tfilter1(c)
	return c1151001.IsLeisp(c) and c:IsAbleToHand()
end
function c1151001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151001.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1151001.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1151001.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
