--真祖（アンベシル）の後裔との接触（エンゲージ）
function c114100526.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c114100526.target)
	e1:SetOperation(c114100526.activate)
	c:RegisterEffect(e1)
end
function c114100526.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c114100526.stfilter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e) and ( c:IsType(TYPE_NORMAL) or c:IsRace(RACE_ZOMBIE) )
end
function c114100526.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and m:IsExists(c114100526.filter3,1,nil,c,m,chkf)
end
function c114100526.stfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x221)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and m:IsExists(c114100526.filter3,1,nil,c,m,chkf)
end
function c114100526.filter3(c,fusc,m,chkf)
	return c:IsSetCard(0x221) and fusc:CheckFusionMaterial(m,c,chkf)
end
function c114100526.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c114100526.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c114100526.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,nil)
		if res then 
			return true 
		else 
			if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
				local stmg1=Duel.GetMatchingGroup(c114100526.stfilter1,tp,LOCATION_DECK,0,nil,e)
				stmg1:Merge(mg1)
				res=Duel.IsExistingMatchingCard(c114100526.stfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,stmg1,nil,chkf)
			end
		end
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c114100526.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c114100526.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c114100526.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c114100526.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,stmg1)
	local stmg1=nil
	local stsg1=nil
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		stmg1=Duel.GetMatchingGroup(c114100526.stfilter1,tp,LOCATION_DECK,0,nil,e)
		stmg1:Merge(mg1)
		stsg1=Duel.GetMatchingGroup(c114100526.stfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,stmg1,nil,chkf)
		sg1:Merge(stsg1)
	end
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c114100526.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		--succeed
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			if tc:IsSetCard(0x221) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
				local gc=stmg1:FilterSelect(tp,c114100526.filter3,1,1,nil,tc,stmg1,chkf):GetFirst()
				local mat1=Duel.SelectFusionMaterial(tp,tc,stmg1,gc,chkf)
				mat1:AddCard(gc)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else
				local gc=mg1:FilterSelect(tp,c114100526.filter3,1,1,nil,tc,mg1,chkf):GetFirst()
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,gc,chkf)
				mat2:AddCard(gc)
				tc:SetMaterial(mat2)
				Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local gc=mg2:FilterSelect(tp,c114100526.filter3,1,1,nil,tc,mg2,chkf):GetFirst()
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,gc,chkf)
			mat2:AddCard(gc)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	else
		--failed
		local cg1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_MZONE,0)
		local cg2=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		local ct=0
		if not Duel.IsPlayerAffectedByEffect(tp,30459350) then
			ct=ct+cg1:GetCount()
			if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
				ct=ct+Duel.GetMatchingGroupCount(c114100526.ctfilter,tp,LOCATION_DECK,0,nil)
			end
		end
		if ct>1 and cg2:IsExists(Card.IsFacedown,1,nil)
			and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,27581098) then
			Duel.ConfirmCards(1-tp,cg1)
			Duel.ConfirmCards(1-tp,cg2)
			Duel.ShuffleHand(tp)
		end
	end
end
function c114100526.ctfilter(c)
	return c:IsType(TYPE_MONSTER) and ( c:IsType(TYPE_NORMAL) or c:IsRace(RACE_ZOMBIE) )
end