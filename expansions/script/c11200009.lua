--鸟笼的提包人 美树沙耶加
function c11200009.initial_effect(c)
	c:EnableReviveLimit() 
	 --fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c11200009.fuscon)
	e1:SetOperation(c11200009.fusop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200009,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11200009)
	e2:SetCost(c11200009.cost)
	e2:SetOperation(c11200009.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11200009)
	e3:SetTarget(c11200009.sptg)
	e3:SetOperation(c11200009.spop)
	c:RegisterEffect(e3)
end
function c11200009.ffilter(c,fc)
	return c11200009.ffilter1(c,fc) or c11200009.ffilter2(c,fc)
end
function c11200009.ffilter1(c,fc)
	return c:IsFusionSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc) 
end
function c11200009.ffilter2(c,fc)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeFusionMaterial(fc) 
end
function c11200004.spfilter1(c,tp,mg,fc)
	  return mg:IsExists(c11200009.spfilter2,1,c,tp,c,fc) 
end
function c11200009.spfilter2(c,tp,mc,fc)
	return ((c11200009.ffilter1(c,fc) and c11200009.ffilter2(mc,fc))
		or (c11200009.ffilter2(c,fc) and c11200009.ffilter1(mc,fc)))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c11200009.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local mg=g:Filter(c11200009.ffilter,nil,c)
	local mg1=g:Filter(c11200009.ffilter1,nil,c)
	local mg2=g:Filter(c11200009.ffilter2,nil,c)
	local tg=Duel.GetMatchingGroup(c11200009.ffilter,tp,LOCATION_DECK,0,nil,c)
	local tg1=Duel.GetMatchingGroup(c11200009.ffilter1,tp,LOCATION_DECK,0,nil,c)
	 local tg2=Duel.GetMatchingGroup(c11200009.ffilter2,tp,LOCATION_DECK,0,nil,c)
	if gc then
		if not mg1:IsContains(gc) and not mg2:IsContains(gc) then return false end
	   if Duel.GetFlagEffect(tp,11200002)~=0 then
		return mg:IsExists(c11200009.spfilter2,1,gc,tp,gc,c) or tg:IsExists(c11200009.spfilter2,1,gc,tp,gc,c)
		else
		return mg:IsExists(c11200009.spfilter2,gc,tp,gc,c) 
end
end
	if Duel.GetFlagEffect(tp,11200002)~=0 and mg1:GetCount()==0 and
	mg2:GetCount()~=0  then
	 return tg1:IsExists(c11200009.spfilter1,1,nil,tp,mg2,c) 
   elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()==0 and
	mg1:GetCount()~=0  then
	return tg2:IsExists(c11200009.spfilter1,1,nil,tp,mg1,c)
	 elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg:GetCount()==1 then
	return tg:IsExists(c11200009.spfilter1,1,nil,tp,mg,c)
	else
	return mg:IsExists(c11200009.spfilter1,1,nil,tp,mg,c) 
end
end
function c11200009.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(c11200009.ffilter,nil,c)
	local mg1=eg:Filter(c11200009.ffilter1,nil,c)
	local mg2=eg:Filter(c11200009.ffilter2,nil,c)
	local tg=Duel.GetMatchingGroup(c11200009.ffilter,tp,LOCATION_DECK,0,nil,c)
	local tg1=Duel.GetMatchingGroup(c11200009.ffilter1,tp,LOCATION_DECK,0,nil,c)
	 local tg2=Duel.GetMatchingGroup(c11200009.ffilter2,tp,LOCATION_DECK,0,nil,c)
	local g=nil
	local sg
	if gc then
		g=Group.FromCards(gc)
		mg:RemoveCard(gc)
	else
	   if Duel.GetFlagEffect(tp,11200002)~=0 and mg1:GetCount()~=0 and
	mg2:GetCount()~=0 and tg:GetCount()>0 and mg:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(11200004,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg:FilterSelect(tp,c11200009.spfilter1,1,1,nil,tp,mg,c)
		Duel.ResetFlagEffect(tp,11200002)
		elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()==0 and mg1:GetCount()~=0 and tg2:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg2:FilterSelect(tp,c11200009.spfilter1,1,1,nil,tp,mg1,c)
		Duel.ResetFlagEffect(tp,11200002)
	   elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg2:GetCount()~=0 and mg1:GetCount()==0 and tg1:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg1:FilterSelect(tp,c11200009.spfilter1,1,1,nil,tp,mg2,c)
		Duel.ResetFlagEffect(tp,11200002)
		 elseif Duel.GetFlagEffect(tp,11200002)~=0 and mg:GetCount()==1  then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=tg:FilterSelect(tp,c11200009.spfilter1,1,1,nil,tp,mg,c)
		Duel.ResetFlagEffect(tp,11200002)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=mg:FilterSelect(tp,c11200009.spfilter1,1,1,nil,tp,mg,c)
		mg:Sub(g)
end
	end
	  if Duel.GetFlagEffect(tp,11200002)~=0 and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11200004,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		sg=tg:FilterSelect(tp,c11200009.spfilter2,1,1,nil,tp,g:GetFirst(),c)
		Duel.ResetFlagEffect(tp,11200002)
		 else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		sg=mg:FilterSelect(tp,c11200009.spfilter2,1,1,nil,tp,g:GetFirst(),c)
end
	g:Merge(sg)
	Duel.SetFusionMaterial(g)
end
function c11200009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	 Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c11200009.operation(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(c11200009.effectfilter)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e2,tp)
end
function c11200009.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp 
end
function c11200009.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c11200009.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c11200009.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x134) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c11200009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c11200009.filter0,tp,LOCATION_GRAVE,0,nil)
		local res=Duel.GetLocationCountFromEx(tp)>0
			and Duel.IsExistingMatchingCard(c11200009.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11200009.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11200009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c11200009.filter1,tp,LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c11200009.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11200009.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if (Duel.GetLocationCountFromEx(tp)>0 and sg1:GetCount()>0) or (sg2~=nil and sg2:GetCount()>0) then
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
