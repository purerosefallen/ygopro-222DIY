--暗堕型富豪亚瑟
function c17060820.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ep effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060820,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060820.epcon)
	e1:SetTarget(c17060820.eptg)
	e1:SetOperation(c17060820.epop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060820,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,17060820)
	e2:SetCost(c17060820.spcost)
	e2:SetTarget(c17060820.sptg)
	e2:SetOperation(c17060820.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060820,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c17060820.fpcon)
	e3:SetTarget(c17060820.fptg)
	e3:SetOperation(c17060820.fpop)
	c:RegisterEffect(e3)
end
c17060820.is_named_with_Regal_Arthur=1
c17060820.is_named_with_Million_Arthur=1
c17060820.is_named_with_Dark_Degenerate=1
function c17060820.IsRegal_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Regal_Arthur
end
function c17060820.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060820.IsDark_Degenerate(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Dark_Degenerate
end
function c17060820.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c17060820.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c17060820.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c17060820.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_PENDULUM) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_PENDULUM)
	Duel.Release(g,REASON_COST)
end
function c17060820.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17060820.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetMZoneCount(tp)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17060820.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c17060820.splimit(e,c)
	return not c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)
end
function c17060820.fpcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL
end
function c17060820.spfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c17060820.spfilter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_WARRIOR) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c17060820.fptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c17060820.spfilter1,nil,e)
		local res=Duel.IsExistingMatchingCard(c17060820.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c17060820.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c17060820.fpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c17060820.spfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c17060820.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c17060820.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
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
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
