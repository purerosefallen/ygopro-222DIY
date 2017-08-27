--幻想游园祭
local m=37564323
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	--Senya.nntr(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	for i=1,3 do
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(m*16+i)
		local ctg=CATEGORY_SPECIAL_SUMMON
		if i==3 then ctg=ctg+CATEGORY_FUSION_SUMMON end
		e2:SetCategory(ctg)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_FZONE)
		e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
		e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
		e2:SetCost(Senya.DescriptionCost())
		e2:SetCondition(cm.rmcon)
		e2:SetTarget(cm.tg[i])
		e2:SetOperation(cm.op[i])
		c:RegisterEffect(e2)
	end
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.tgfilter(c)
	if not c:IsAbleToGrave() or not c:IsType(TYPE_MONSTER) then return false end
	if Senya.check_set_3L(c) then return true end
	if Senya.check_set_sawawa(c) then return true end
	if Senya.check_set_sayuri(c) then return true end
	if c.Senya_desc_with_nanahira then return true end
	return false
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function cm.filter1(c,e,tp)
	if not c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) then return false end
	if c:GetLevel()==4 and Senya.check_set_sayuri(c) then return true end
	if c:GetLevel()==8 and Senya.check_set_sawawa(c) then return true end
	return false
end
function cm.mgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(nil) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.filtergoal(g,xyzc,tp)
	local ct=g:GetCount()
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 and xyzc:IsXyzSummonable(g,ct,ct)
end
function cm.xfilter(c,mg,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and Senya.CheckGroup(mg,cm.filtergoal,nil,1,63,c,tp)
end
function cm.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and (Senya.check_set_3L(c) or c.Senya_desc_with_nanahira)
end
cm.tg={
[1]=function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end,
[2]=function(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.mgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_EXTRA,0,nil,mg,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end,
[3]=function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Senya.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end,
}
cm.op={
[1]=function(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		Duel.RegisterEffect(e1,tp)
	end
end,
[2]=function(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(cm.mgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_EXTRA,0,nil,mg,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local sg=Senya.SelectGroup(tp,HINTMSG_XMATERIAL,mg,cm.filtergoal,nil,1,63,tc,tp)
	Duel.XyzSummon(tp,tc,sg)
	Duel.ShuffleHand(tp)
end,
[3]=function(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=tp
	local mg1=Senya.GetFusionMaterial(tp,nil,nil,nil,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end,
}
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end