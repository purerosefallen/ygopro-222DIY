--眷 粉 的 绚 樱 ·月 与 海
function c46564005.initial_effect(c)
	c:SetSPSummonOnce(46564005) 
	--loven paly
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c46564005.vcon)
	e0:SetOperation(c46564005.loven)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEDOWN_DEFENSE,0)   
	e1:SetCondition(c46564005.spcon)
	e1:SetValue(0x656)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(46564005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c46564005.fscon)
	e2:SetTarget(c46564005.target)
	e2:SetOperation(c46564005.operation)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c46564005.condition)
	e3:SetCost(c46564005.cost)
	e3:SetTarget(c46564005.retg)
	e3:SetOperation(c46564005.reop)
	c:RegisterEffect(e3)
end
function c46564005.vcon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x656)==0x656
end
function c46564005.loven(e,tp,eg)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(46564005,0))
	if bit.band(e:GetHandler():GetSummonType(),0x656)==0x656 then   Duel.ConfirmCards(1-tp,e:GetHandler()) 
	end
end
function c46564005.cfilter(c)
	return c:IsLevelAbove(5)
end
function c46564005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and not Duel.IsExistingMatchingCard(c46564005.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c46564005.fscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL
end
function c46564005.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c46564005.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c46564005.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c46564005.filter3(c,e)
	return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)
end
function c46564005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local mg2=Duel.GetMatchingGroup(c46564005.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c46564005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg4=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c46564005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c46564005.operation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c46564005.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(c46564005.filter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c46564005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg4=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg4=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c46564005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg4,mf,chkf)
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end  ------------------\\\\e3\\\\
function c46564005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c46564005.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_FUSION) and rc~=c and rc:IsControler(tp) and loc==LOCATION_MZONE and rc:IsLocation(LOCATION_MZONE)
	and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c46564005.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c46564005.reop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())	   
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		rc:RegisterEffect(e1)
	end
end


