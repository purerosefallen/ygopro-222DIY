--P.E.T.S.-Thoth 布偶猫菲妮尔
function c777005.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(777005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,777005)
	e1:SetCondition(c777005.spcon)
	e1:SetTarget(c777005.sptg)
	e1:SetOperation(c777005.spop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(777005,4))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,777105)
	e2:SetTarget(c777005.ctltg)
	e2:SetOperation(c777005.ctlop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--fusion
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(777005,5))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCost(c777005.pfcost)
	e4:SetTarget(c777005.pftg)
	e4:SetOperation(c777005.pfop)
	c:RegisterEffect(e4)
end

c777005.is_named_with_PETS=1
function c777005.IsPETS(c)
	local code=c:GetCode()
	local mt=_G["c"..code]
	if not mt then
		_G["c"..code]={}
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			mt=_G["c"..code]
			_G["c"..code]=nil
		else
			_G["c"..code]=nil
			return false
		end
	end
	return mt and mt.is_named_with_PETS
end


function c777005.cfilter(c)
	return c:IsFaceup() and c777005.IsPETS(c)
end

function c777005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c777005.cfilter,tp,0,LOCATION_MZONE,1,nil) 
end

function c777005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMZoneCount(tp)>0 or Duel.GetMZoneCount(1-tp)>0)
		and (e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) or e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c777005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local s1=Duel.GetMZoneCount(tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetMZoneCount(1-tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777005,1),aux.Stringid(777005,2))
	elseif s1 and not s2 then op=Duel.SelectOption(tp,aux.Stringid(777005,1))
	elseif not s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777005,2))+1
	elseif not s1 and not s2 then return end
	if op==0 then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	else Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1,true)
end


function c777005.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end

function c777005.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end


function c777005.pffilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c777005.pffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function c777005.pfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c777005.pftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c777005.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c777005.pffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c777005.pfop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c777005.pffilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c777005.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c777005.pffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
