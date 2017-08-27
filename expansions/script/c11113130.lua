--结界融合
function c11113130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11113130,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11113130.sptg)
	e1:SetOperation(c11113130.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113130,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11113130)
	e2:SetCondition(c11113130.discon)
	e2:SetCost(c11113130.discost)
	e2:SetTarget(c11113130.distg)
	e2:SetOperation(c11113130.disop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c11113130.reptg)
	e3:SetValue(c11113130.repval)
	e3:SetOperation(c11113130.repop)
	c:RegisterEffect(e3)
end
function c11113130.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c11113130.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c11113130.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c11113130.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FAIRY) and c:GetLevel()==10 and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11113130.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCode(11113129) and (not f or f(c)) 
	    and m:IsExists(c11113130.mfilter1,1,nil,m,c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11113130.mfilter1(c,g,fc)
	return c:GetLevel()==4 and c:GetAttack()==1000 and c:GetDefense()==1000 
	    and c:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and c:IsCanBeFusionMaterial(fc)
	    and g:IsExists(c11113130.mfilter2,1,nil,c:GetAttribute(),fc)
end
function c11113130.mfilter2(c,att,fc)
	return c:GetLevel()==4 and c:GetAttack()==1000 and c:GetDefense()==1000 
	    and c:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and c:IsCanBeFusionMaterial(fc)
	    and not c:IsAttribute(att)
end
function c11113130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c11113130.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c11113130.filter2,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c11113130.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		local mg3=Duel.GetMatchingGroup(c11113130.filter2,tp,LOCATION_DECK,0,nil)
		mg3:Merge(mg1)
		res=Duel.IsExistingMatchingCard(c11113130.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg4=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11113130.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11113130.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c11113130.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c11113130.filter2,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c11113130.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=Duel.GetMatchingGroup(c11113130.filter2,tp,LOCATION_DECK,0,nil)
	mg3:Merge(mg1)
	local sg2=Duel.GetMatchingGroup(c11113130.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,nil,chkf)
	sg1:Merge(sg2)
	local mg4=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg4=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c11113130.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg4,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		    if tc:IsCode(11113129) and mg3:IsExists(c11113130.mfilter1,1,nil,mg3) then
			    tc:RegisterFlagEffect(11113130,RESET_CHAIN,0,1)
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else	
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat2)
				Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end	
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg4,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function c11113130.tfilter(c,tp)
	return c:IsFaceup() and c:GetLevel()==10 and c:IsType(TYPE_FUSION) and c:IsRace(RACE_FAIRY)
	    and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c11113130.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11113130.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c11113130.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11113130.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11113130.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c11113130.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_FUSION)
		and c:GetLevel()==10 and c:IsRace(RACE_FAIRY) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c11113130.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c11113130.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(11113130,2))
end
function c11113130.repval(e,c)
	return c11113130.repfilter(c,e:GetHandlerPlayer())
end
function c11113130.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end