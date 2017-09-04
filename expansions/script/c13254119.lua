--飞球融合·流石
function c13254119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254119,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13254119.target)
	e1:SetOperation(c13254119.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(13254119,1))
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c13254119.target1)
	e2:SetOperation(c13254119.activate1)
	c:RegisterEffect(e2)
	
end
function c13254119.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c13254119.filter2(c,m)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x356) and c:CheckFusionMaterial(m)
end
function c13254119.filter3(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x356) and (not f or f(c))
		and c:IsAbleToGrave() and c:CheckFusionMaterial(m,nil,chkf)
end
function c13254119.filter4(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c13254119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c13254119.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	return res end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c13254119.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c13254119.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c13254119.filter2,tp,LOCATION_EXTRA,0,nil,mg1)
	if sg1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetCode()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg1)
		tc:SetMaterial(mat)
		if Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)~=0 then
			Duel.BreakEffect()
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end
function c13254119.filter1a(c,e)
	return not c:IsImmuneToEffect(e) and c:IsOnField()
end
function c13254119.filter2a(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x356) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function c13254119.filter4a(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c13254119.filter5a(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c13254119.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetMatchingGroup(c13254119.filter4a,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c13254119.filter2a,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c13254119.filter2a,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c13254119.activate1(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c13254119.filter1a,nil,e)
	local mg2=Duel.GetMatchingGroup(c13254119.filter5a,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c13254119.filter2a,tp,LOCATION_GRAVE,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c13254119.filter2a,tp,LOCATION_GRAVE,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
