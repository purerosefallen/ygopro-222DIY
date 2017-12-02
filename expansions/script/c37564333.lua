--仙境的漫游者·Kana
local m=37564333
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_kana=true
function cm.initial_effect(c)
	Senya.AddXyzProcedureCustom(c,cm.xfilter,cm.gcheck,2,2)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCost(Senya.RemoveOverlayCost(2))
	e0:SetTarget(cm.mttg)
	e0:SetOperation(cm.mtop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetLabelObject(e2)
	e3:SetCost(Senya.ForbiddenCost())
	e3:SetCondition(cm.spcon2)
	e3:SetTarget(cm.sptg2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)
end
function cm.xfilter(c,xyzcard)
	return c:IsXyzType(TYPE_FUSION) and c.material
end
function cm.gcheck(g)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local mt1=tc1.material
	for i,code1 in pairs(tc1.material) do
		for j,code2 in pairs(tc2.material) do
			if code1==code2 then return false end
		end
	end
	return true
end
function cm.mtfilter(c)
	return c:IsType(TYPE_FUSION)
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function cm.filter1(c,e,tp,og)
	if ft==0 and c:GetSequence()>4 then return false end
	return c:IsFaceup() and Duel.IsExistingTarget(cm.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp,og,c)
end
function cm.filter2(c,e,tp,og,mc)
	local g=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsAbleToChangeControler() and og:IsExists(cm.filter3,1,nil,e,tp,g) and Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.filter3(c,e,tp,mg)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) and Senya.CheckFusionMaterialExact(c,mg,PLAYER_NONE)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local og=e:GetHandler():GetOverlayGroup()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,c,e,tp,og) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,c,e,tp,og,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=Duel.SelectTarget(tp,cm.filter2,tp,0,LOCATION_MZONE,1,1,nil,e,tp,og,g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,og,1,0,0)
end
function cm.counterfilter(c,e)
	return c:IsFacedown() or not c:IsRelateToEffect(e)
end
function cm.checklocationfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<=4
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsControler(1-tp) then return end
	local og=e:GetHandler():GetOverlayGroup()
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if mg:IsExists(cm.counterfilter,1,nil,e) then return end
	if Duel.GetMZoneCount(tp,mg,tp)<=0 then return end
	local fg=og:Filter(cm.filter3,nil,e,tp,mg)
	if fg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=fg:Select(tp,1,1,nil):GetFirst()
		tc:SetMaterial(mg)
		Senya.OverlayGroup(c,mg)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local og=e:GetHandler():GetOverlayGroup():Clone()
	og:KeepAlive()
	e:SetLabelObject(og)
	return false
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return (r & REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function cm.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.mfilter(c,og)
	return c:IsAbleToRemove() and og and og:IsContains(c)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local l=e:GetLabel()
	e:SetLabel(0)
	if chk==0 then
		if l~=1 then return false end
		local chkf=tp
		local og=e:GetLabelObject():GetLabelObject()
		local mg1=Senya.GetFusionMaterial(tp,LOCATION_GRAVE,LOCATION_GRAVE,cm.mfilter,nil,nil,og)
		local res=Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local og=e:GetLabelObject():GetLabelObject()
	local mg1=Senya.GetFusionMaterial(tp,LOCATION_GRAVE,LOCATION_GRAVE,cm.mfilter,nil,e,og)
	local sg1=Duel.GetMatchingGroup(cm.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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