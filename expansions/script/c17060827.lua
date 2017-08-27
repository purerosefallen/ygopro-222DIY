--感谢壕
function c17060827.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion (p)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060827,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060827)
	e1:SetTarget(c17060827.pftg)
	e1:SetOperation(c17060827.pfop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060827,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,17060827+100)
	e2:SetTarget(c17060827.tdtg)
	e2:SetOperation(c17060827.tdop)
	c:RegisterEffect(e2)
end
c17060827.is_named_with_Regal_Arthur=1
c17060827.is_named_with_Million_Arthur=1
function c17060827.IsRegal_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Regal_Arthur
end
function c17060827.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060827.pffilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c17060827.pffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c17060827.exfilter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c17060827.exfilter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c17060827.pftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local sg=Duel.GetMatchingGroup(c17060827.exfilter0,tp,LOCATION_EXTRA,0,nil)
		if sg:GetCount()>0 then
			mg1:Merge(sg)
		end
		local res=Duel.IsExistingMatchingCard(c17060827.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c17060827.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c17060827.pfop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c17060827.pffilter1,nil,e)
	local exmat=false
	local sg0=Duel.GetMatchingGroup(c17060827.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
	if sg0:GetCount()>0 then
		mg1:Merge(sg0)
		exmat=true
	end
	if exmat then Auxiliary.FCheckAdditional=c17060827.fcheck end
	local sg1=Duel.GetMatchingGroup(c17060827.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c17060827.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
end
function c17060827.tdfilter(c)
	return c17060827.IsMillion_Arthur(c) and c:IsAbleToDeck()
end
function c17060827.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c17060827.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17060827.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c17060827.tdfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c17060827.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
