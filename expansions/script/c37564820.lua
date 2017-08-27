--3L·Keep the Faith
local m=37564820
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(aux.exccon)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.effect_operation_3L(c,ctlm)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(ctlm)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetTarget(cm.rtg)
	e1:SetOperation(cm.rop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	return e1
end
--[[cm.reset_operation_3L={
function(e,c)
	local copym=c:GetFlagEffectLabel(m)
	if not copym then return end
	local copyt=Senya.order_table[copym]
	for i,dt in pairs(copyt) do
		Duel.Hint(HINT_OPSELECTED,c:GetControler(),m*16+2)
		c:ResetEffect(dt.ccid,RESET_COPY)
	end
	c:ResetFlagEffect(m)
end,
}]]
function cm.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and Senya.check_set_3L(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if not c:IsAbleToRemove() then return false end
		local chkf=tp
		local mg1=Senya.GetFusionMaterial(tp,LOCATION_ONFIELD+LOCATION_GRAVE,nil,Card.IsAbleToRemove,c)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsAbleToRemove() then return end
	local chkf=tp
	local mg1=Senya.GetFusionMaterial(tp,LOCATION_ONFIELD+LOCATION_GRAVE,nil,Card.IsAbleToRemove,c,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()==0 then return end
	local gc=g:RandomSelect(tp,1):GetFirst()
	Duel.Remove(gc,POS_FACEUP,REASON_EFFECT)
	local code=gc:GetOriginalCode()
	if not gc:IsType(TYPE_TRAPMONSTER) then  
		local cid=Senya.CopyEffectExtraCount(c,Senya.CheckKoishiCount(c),code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		if c:GetFlagEffect(m)==0 then
			local tcode=Senya.order_table_new({{ccode=code,ccid=cid}})
			c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2,tcode)
		else
			local copyt=Senya.order_table[c:GetFlagEffectLabel(m)]
			table.insert(copyt,{ccode=code,ccid=cid})
		end
	end
end