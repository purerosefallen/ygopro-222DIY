--White Lotus
local m=37564328
local cm=_G["c"..m]
local coroutine=require("coroutine")
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter2(c,e,tp,m,f,chkf,sgf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and not (sgf and sgf:IsContains(c))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=PLAYER_NONE
		local mg1=Senya.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function cm.ffilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.nfilter(c,g,t)
	if g and g:IsContains(c) then return false end
	if t then
		for cc,g1 in pairs(t) do
			if g1:IsContains(c) then return false end
		end
	end
	return true
end
function cm.fieldcheck(tp,mgf,sgf,co)
	local ft=Duel.GetMZoneCount(tp)-sgf:GetCount()+mgf:FilterCount(cm.ffilter,nil,tp)
	for fc,mg in pairs(co) do
		ft=ft+mg:FilterCount(cm.ffilter,nil,tp)
	end
	return ft>0 and PLAYER_NONE or tp
end
function cm.fselect(tp,fc,mg,mgf,sgf,co)
	local f=Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx=cm.fcheck(f,mgf,sgf,co)
	local g=Duel.SelectFusionMaterial(tp,fc,mg,nil,PLAYER_NONE)
	Duel.GetLocationCountFromEx=f
	return g
end
function cm.fcheck(f,mgf,sgf,co)
	return function(p1,p2,g,fc)
		local tg=g:Clone()
		tg:Merge(mgf)
		for fc,mg in pairs(co) do
			tg:Merge(mg)
		end
		return f(p1,p2,tg,fc)-sgf:GetCount()
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mgf=Group.CreateGroup()
	local sgf=Group.CreateGroup()
	local co={}
	local crt={}
	local mg1=Senya.GetFusionMaterial(tp,nil,nil,cm.nfilter,nil,e,mgf,co)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,PLAYER_NONE,sgf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(cm.nfilter,nil,mgf,co)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,PLAYER_NONE,sgf,co)
	end
	local check=true
	while (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and (check or (not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,210))) do
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=cm.fselect(tp,tc,mg,mgf,sgf,co)
			tc:SetMaterial(mat1)
			mgf:Merge(mat1)
			sgf:AddCard(tc)
		else
			local mat2=cm.fselect(tp,tc,mg,mgf,sgf,co)
			sgf:AddCard(tc)
			local fop=ce:GetOperation()
			co[tc]=mat2
			crt[tc]=coroutine.create(cm.crop(fop,ce,e,tp,tc,mat2))
		end
		mg1=Senya.GetFusionMaterial(tp,nil,nil,cm.nfilter,nil,e,mgf,co)
		sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,PLAYER_NONE,sgf)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp):Filter(cm.nfilter,nil,mgf,co)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,PLAYER_NONE,sgf)
		end
		check=false
	end
	if sgf:GetCount()>0 then
		Duel.SendtoGrave(mgf,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		local f1=Duel.SpecialSummon
		local f2=Duel.SpecialSummonStep
		local f3=Duel.SpecialSummonComplete
		local f4=Duel.BreakEffect
		local f5=Card.CompleteProcedure
		Duel.SpecialSummon=cm.stop
		Duel.SpecialSummonStep=cm.stop
		Duel.SpecialSummonComplete=aux.NULL
		Duel.BreakEffect=aux.NULL
		Card.CompleteProcedure=aux.NULL
		for i,cr in pairs(crt) do
			coroutine.resume(cr)
		end
		f4()
		f1(sgf,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummon=aux.NULL
		Duel.SpecialSummonStep=aux.NULL
		for sc in aux.Next(sgf) do
			f5(sc)
		end
		for i,cr in pairs(crt) do
			coroutine.resume(cr)
		end
		Duel.SpecialSummon=f1
		Duel.SpecialSummonStep=f2
		Duel.SpecialSummonComplete=f3
		Duel.BreakEffect=f4
		Card.CompleteProcedure=f5
	end
end
function cm.stop()
	coroutine.yield()
end
function cm.crop(fop,ce,e,tp,tc,mat)
	return function()
		fop(ce,e,tp,tc,mat)
	end
end