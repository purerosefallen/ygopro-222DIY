--秋语 彼岸花·回忆
function c10105006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10105006.ffilter,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10105006.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10105006.spcon)
	e2:SetOperation(c10105006.spop)
	c:RegisterEffect(e2)
	--Fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105006,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0+TIMING_MAIN_END)
	e3:SetCountLimit(1,10105006)
	e3:SetTarget(c10105006.fustg)
	e3:SetOperation(c10105006.fusop)
	c:RegisterEffect(e3) 
end
function c10105006.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c10105006.filter2(c,e,tp,mg,f,rc,chkf,ct)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc330) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and ((c:CheckFusionMaterial(mg,nil,chkf) and ct==0) or (c:CheckFusionMaterial(mg,rc,chkf) and ct==1))
end
function c10105006.fusfilter(c)
	return c:IsCanBeFusionMaterial() and ((c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND)) or c:IsLocation(LOCATION_HAND+LOCATION_MZONE))
end
function c10105006.fusfilter2(c,e)
	return c10105006.fusfilter(c) and not c:IsImmuneToEffect(e)
end
function c10105006.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local mg2=Duel.GetMatchingGroup(c10105006.fusfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil)
		local res1=Duel.IsExistingMatchingCard(c10105006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf,0)
		local res2=Duel.IsExistingMatchingCard(c10105006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,c,chkf,1)
		if not res1 and not res2 then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res1=Duel.IsExistingMatchingCard(c10105006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res1 or res2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10105006.fusop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c10105006.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c10105006.fusfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c10105006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf,0)
	local sg2=Duel.GetMatchingGroup(c10105006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,c,chkf,1)
	local mg3,sg3,mat1=nil
	if not c:IsRelateToEffect(e) then sg2:Clear() end
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c10105006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or sg2:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		sg:Merge(sg2)
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		local tf1=(sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription()))
		local tf2,tf3,op=sg1:IsContains(tc),sg2:IsContains(tc),0
		if not c:IsRelateToEffect(e) then tf3=false end
		if tf1 then
		   if tf2 and tf3 then
			   if Duel.SelectYesNo(tp,aux.Stringid(10105006,1)) then
				  op=3
			   else op=2
			   end
		   elseif tf2 then op=2
		   elseif tf3 then op=3
		   end
		   if op==2 then mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		   else mat1=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
		   end
		   tc:SetMaterial(mat1)
		   Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		   Duel.BreakEffect()
		   Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end  
function c10105006.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)
end
function c10105006.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c10105006.spfilter(c,tp,fc)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial(fc)
end
function c10105006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>-2
		and Duel.CheckReleaseGroup(tp,c10105006.spfilter,2,nil,tp,c)
end
function c10105006.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c10105006.spfilter,2,2,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end