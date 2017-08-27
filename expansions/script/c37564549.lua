--Aqua Trytone
local m=37564549
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	--Senya.nntr(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.activate)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetLabelObject(e0)
	e1:SetCost(Senya.SelfRemoveCost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.mfilter(c,e)
	if e and c:IsImmuneToEffect(e) then return false end
	return c:GetOriginalCode()==37564765 and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Senya.GetFusionMaterial(tp)
		local mgg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mgg)
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
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Senya.GetFusionMaterial(tp,nil,nil,nil,nil,e)
	local mgg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil,e)
	mg1:Merge(mgg)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			mat1:Remove(Card.IsLocation,nil,LOCATION_GRAVE)
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,m*16)
		tc:CompleteProcedure()
		e:SetLabelObject(tc)
	end
end
function cm.f2(c,e,tp,tc)
	return c.Senya_desc_with_nanahira and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationFromEx(tp,tp,Group.FromCards(tc),c)>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	if chk==0 then
		if not te then return false end
		local tc=te:GetLabelObject()
		if not tc or tc:GetFlagEffect(m)==0 or not tc:IsAbleToExtra() then return false end
		local ft=0
		if tc:IsControler(tp) then ft=-1 end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=ft then return false end
		if not Duel.IsExistingMatchingCard(cm.f2,tp,LOCATION_EXTRA,0,1,tc,e,tp,tc) then return false end
		return tc==Duel.GetAttacker() or tc==Duel.GetAttackTarget()
	end
	local tc=te:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsAbleToExtra() or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.f2,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end