--梦魇融合
function c10129006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10129006+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10129006.target)
	e1:SetOperation(c10129006.activate)
	c:RegisterEffect(e1)	
end
c10129006.card_code_list={10129007}
function c10129006.filter0(c)
	return c:IsCanBeFusionMaterial() and ((c:IsAbleToRemove() and c:IsLocation(LOCATION_GRAVE)) or c:IsLocation(LOCATION_MZONE+LOCATION_HAND))
end
function c10129006.filter1(c,e)
	return c:IsCanBeFusionMaterial() and ((c:IsAbleToRemove() and c:IsLocation(LOCATION_GRAVE)) or c:IsLocation(LOCATION_MZONE+LOCATION_HAND)) and not c:IsImmuneToEffect(e)
end
function c10129006.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1 and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+101,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c10129006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c10129006.filter0,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil)
		local res=Duel.IsExistingMatchingCard(c10129006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10129006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10129006.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c10129006.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c10129006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10129006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local mat3=mat1:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_ONFIELD)
			if mat3:GetCount()>0 then
			   Duel.SendtoGrave(mat3,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			   mat1:Sub(mat3)
			end
			if mat1:GetCount()>0 then
			   Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+101,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2,SUMMON_TYPE_FUSION+101)
		end
		tc:CompleteProcedure()
	end
end