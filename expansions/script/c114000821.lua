--バーコード・フュージョン
function c114000821.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c114000821.target)
	e1:SetOperation(c114000821.activate)
	c:RegisterEffect(e1)
end
function c114000821.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c114000821.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
--check
function c114000821.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		--without chain material
		local mg1=Duel.GetMatchingGroup(c114000821.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
		local mgct=mg1:GetCount()
		local mgpt=mg1:GetFirst()
		local mgc={}
		local mgchk=nil
		local res=false 
		for i=1,mgct do
			mgc[i]=mgpt
			mgpt=mg1:GetNext()
		end
		for i=1,mgct do
			for j=i,mgct do
				mgchk=Group.FromCards(mgc[i],mgc[j])
				if mgchk:IsExists(Card.IsSetCard,1,nil,0x221) then
					res=Duel.IsExistingMatchingCard(c114000821.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mgchk,nil,chkf)
				end
				if res then break end
			end
			if res then break end
		end
		--with chain material
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				--checking
				mgct=mg2:GetCount()
				mgpt=mg2:GetFirst()
				for i=1,mgct do
					mgc[i]=mgpt
					mgpt=mg2:GetNext()
				end
				for i=1,mgct do
					for j=i,mgct do
						mgchk=Group.FromCards(mgc[i],mgc[j])
						if mgchk:IsExists(Card.IsSetCard,1,nil,0x221) then
							res=Duel.IsExistingMatchingCard(c114000821.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mgchk,mf,chkf)
						end
						if res then break end
					end
					if res then break end
				end				
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--function
function c114000821.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	--without chain material
	local mg1=Duel.GetMatchingGroup(c114000821.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil,e)
	--check
	local mgct=mg1:GetCount()
	local mgpt=mg1:GetFirst()
	local mgc={}
	local mgchk=nil
	local sg1=Group.CreateGroup()
	local chg=Group.CreateGroup()
	for i=1,mgct do
		mgc[i]=mgpt
		mgpt=mg1:GetNext()
	end
	for i=1,mgct do
		for j=i,mgct do
			mgchk=Group.FromCards(mgc[i],mgc[j])
			if mgchk:IsExists(Card.IsSetCard,1,nil,0x221) then
				chg=Duel.GetMatchingGroup(c114000821.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mgchk,nil,chkf)
				if chg:GetCount()>0 then sg1:Merge(chg) end
			end
		end
	end
	--with chain material
	local mg2=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		--check
		local mgct2=mg2:GetCount()
		local mgpt2=mg2:GetFirst()
		local mgc2={}
		for i=1,mgct2 do
			mgc2[i]=mgpt2
			mgpt2=mg2:GetNext()
		end
		for i=1,mgct2 do
			for j=i,mgct2 do
				mgchk=Group.FromCards(mgc2[i],mgc2[j])
				if mgchk:IsExists(Card.IsSetCard,1,nil,0x221) then
					chg=Duel.GetMatchingGroup(c114000821.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mgchk,mf,chkf)
					if chg:GetCount()>0 then sg2:Merge(chg) end
				end
			end
		end			
	end
	--determine whether effect is applied
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			--material 1
			local matst=Group.CreateGroup()
			for i=1,mgct do
				if mgc[i]:IsSetCard(0x221) then
					for j=1,mgct do
						mgchk=Group.FromCards(mgc[i],mgc[j])
						if tc:CheckFusionMaterial(mgchk,nil,chkf) and i~=j then
							matst:AddCard(mgc[i])
							break
						end
					end
				end
			end
			local matc1=matst:Select(tp,1,1,nil)
			local mats1=matc1:GetFirst()
			--material 2
			local mg3=mg1:Clone()
			mg3:RemoveCard(mats1)
			local mats2ct=mg3:GetCount()
			local mgmat2={}
			local mats2pt=mg3:GetFirst()
			local matst2=Group.CreateGroup()
			for i=1,mats2ct do
				mgmat2[i]=mats2pt
				mgchk=Group.FromCards(mats1,mgmat2[i])
				chg=tc:CheckFusionMaterial(mgchk,nil,chkf)
				if chg then matst2:AddCard(mgmat2[i]) end
				mats2pt=mg3:GetNext()
			end
			local matc2=matst2:Select(tp,1,1,nil)
			local mats2=matc2:GetFirst()
			local mat1=Group.FromCards(mats1,mats2)
			--local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			--fusion part
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
		--chain material material 1
			local matst=Group.CreateGroup()
			local mgct2=mg2:GetCount()
			local mgpt2=mg2:GetFirst()
			local mgc2={}
			for i=1,mgct2 do
				mgc2[i]=mgpt2
				mgpt2=mg2:GetNext()
			end
			for i=1,mgct2 do
				if mgc2[i]:IsSetCard(0x221) then
					for j=1,mgct2 do
						mgchk=Group.FromCards(mgc2[i],mgc2[j])
						if tc:CheckFusionMaterial(mgchk,nil,chkf) and i~=j then
							matst:AddCard(mgc2[i])
							break
						end
					end
				end
			end
			local matc1=matst:Select(tp,1,1,nil)
			local mats1=matc1:GetFirst()
		--chain material material 2
			local mg3=mg2:Clone()
			mg3:RemoveCard(mats1)
			local mats2ct=mg3:GetCount()
			local mgmat2={}
			local mats2pt=mg3:GetFirst()
			local matst2=Group.CreateGroup()
			for i=1,mats2ct do
				mgmat2[i]=mats2pt
				mgchk=Group.FromCards(mats1,mgmat2[i])
				chg=tc:CheckFusionMaterial(mgchk,nil,chkf)
				if chg then matst2:AddCard(mgmat2[i]) end
				mats2pt=mg3:GetNext()
			end
			local matc2=matst2:Select(tp,1,1,nil)
			local mats2=matc2:GetFirst()
			local mat2=Group.FromCards(mats1,mats2)
			--local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			--fusion part
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end