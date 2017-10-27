--hana
local m=37564307
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.ffilter,2,63,false)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetCode(EFFECT_SPSUMMON_CONDITION)
	ex:SetValue(cm.splimit)
	c:RegisterEffect(ex)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(function()
		return Duel.GetCurrentPhase()>PHASE_MAIN1 and Duel.GetCurrentPhase()<PHASE_MAIN2
	end)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(ex)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(Senya.SelfReleaseCost)
	e7:SetTarget(cm.spptg)
	e7:SetOperation(cm.sppop)
	c:RegisterEffect(e7)
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION
end
function cm.ffilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsOnField()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Senya.GetFusionMaterial(tp,LOCATION_ONFIELD)
		local res=cm.filter2(c,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=cm.filter2(c,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_EXTRA)
end
function cm.val(c)
	return math.max(c:GetAttack(),0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Senya.GetFusionMaterial(tp,LOCATION_ONFIELD,nil,nil,nil,e)
	local r1=cm.filter2(c,e,tp,mg1,nil,chkf)
	local r2=false
	local val=0
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		r2=cm.filter2(c,e,tp,mg2,mf,chkf)
	end
	if r1 or r2 then
		if not (r2 and Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,c,mg1,nil,chkf)
			val=val+mat1:GetSum(cm.val)
			c:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,c,mg2,nil,chkf)
			val=val+mat2:GetSum(cm.val)
			local fop=ce:GetOperation()
			fop(ce,e,tp,c,mat2)
		end
		c:CompleteProcedure()
		if val>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(math.floor(val/2))
			c:RegisterEffect(e1,true)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.spptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local sumtype=c:GetSummonType()
	if chk==0 then   
		return not (bit.band(sumtype,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION or mg:GetCount()==0
		or mg:GetCount()>Duel.GetMZoneCount(tp)
		or mg:IsExists(cm.mgfilter,1,nil,e,tp,c))
	end
	mg:KeepAlive()
	e:SetLabelObject(mg)
	Duel.SetTargetCard(mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function cm.mgfilter(c,e,tp,fusc)
	return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE)
		or bit.band(c:GetReason(),0x40008)~=0x40008 or c:GetReasonCard()~=fusc
		or not c:IsCanBeSpecialSummoned(e,0,tp,true,true) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.mgfilterx(c,e,tp,fusc)
	return not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,true,true) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.sppop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetLabelObject()
	local g=mg:Clone()
	mg:DeleteGroup()
	if not (g:GetCount()==0
		or g:GetCount()>Duel.GetMZoneCount(tp)
		or g:IsExists(cm.mgfilterx,1,nil,e,tp,c)) then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3,true)
			tc:CompleteProcedure()
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end