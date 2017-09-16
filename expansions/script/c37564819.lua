--3L·苍空之舞-墨染之樱
local m=37564819
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.effect_operation_3L(c,ctlm)
	local e=Senya.InstantCopyModule(c,ctlm)
	e:SetReset(RESET_EVENT+0x1fe0000)
	e:SetDescription(m*16+1)
	e:SetCost(Senya.DescriptionCost(e:GetCost()))
	c:RegisterEffect(e,true)
	return e
end
function cm.flimit(gc)
	return function(tp,g,fc)
		return not g:IsExists(Senya.NOT(Senya.check_fusion_set_3L),1,gc)
	end
end
function cm.fcheck(c,m,gc,chkf)
	aux.FCheckAdditional=cm.flimit(gc)
	local res=c:CheckFusionMaterial(m,gc,chkf)
	aux.FCheckAdditional=nil
	return res
end

function cm.fselect(tp,tc,mg,gc,chkf)
	aux.FCheckAdditional=cm.flimit(gc)
	local g=Duel.SelectFusionMaterial(tp,tc,mg,gc,chkf)
	aux.FCheckAdditional=nil
	return g
end
function cm.spfilter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and Senya.check_set_3L(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and cm.fcheck(c,m,gc,chkf)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Senya.GetFusionMaterial(tp,nil,nil,Senya.check_set_3L,c)
		local res=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):Filter(Senya.check_set_3L,nil)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local chkf=tp
	local mg1=Senya.GetFusionMaterial(tp,nil,nil,Senya.check_set_3L,c,e)
	local sg1=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(Senya.check_set_3L,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=cm.fselect(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=cm.fselect(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end