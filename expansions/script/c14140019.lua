--圣少女的牲祭品
local m=14140019
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c14141006") end,function() require("script/c14141006") end)
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,m)
	scorp.AddXyzProcedureCustom(c,cm.mfilter,cm.xyzcheck,3,63)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(0x14000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(cm.dtg)
	e1:SetOperation(cm.dop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(cm.tg1)
	e2:SetOperation(cm.op1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+1)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:GetOriginalLevel()>0
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetOriginalLevel)==g:GetCount()
end
function cm.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and eg:IsExists(cm.filter,1,e:GetHandler(),tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,eg,eg:GetCount(),0,0)
end
function cm.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and cm.filter(c,tp) and not c:IsImmuneToEffect(e)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local g=eg:Filter(cm.filter2,e:GetHandler(),e,tp)
	Duel.Overlay(e:GetHandler(),g)
end
function cm.checkfield(tp)
	if Duel.GetLocationCountFromEx then return Duel.GetLocationCountFromEx(tp)>0 end
	return Duel.GetMZoneCount(tp)>0
end
function cm.filtergoal(g,xyzc)
	local ct=g:GetCount()
	return xyzc:IsXyzSummonable(g,ct,ct)
end
function cm.xfilter(c,mg)
	return c:IsType(TYPE_XYZ) and scorp.CheckGroup(mg,cm.filtergoal,nil,1,63,c)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	local g=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return g:GetCount()>0 and cm.checkfield(tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not cm.checkfield(tp) or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local mg=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	local g=Duel.GetMatchingGroup(cm.xfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local sg=scorp.SelectGroup(tp,HINTMSG_XMATERIAL,mg,cm.filtergoal,nil,1,63,tc)
	--[[tc:SetMaterial(sg)
	local mc=sg:GetFirst()
	local sg1=sg:Filter(aux.TRUE,mc)
	Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
	Duel.Overlay(mc,sg1)
	Duel.Overlay(tc,sg)]]
	Duel.XyzSummon(tp,tc,sg)
end
function cm.ffilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function cm.ffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not cm.checkfield(tp) then return false end
		local chkf=PLAYER_NONE
		local mg1=e:GetHandler():GetOverlayGroup():Filter(cm.ffilter1,nil)
		local res=Duel.IsExistingMatchingCard(cm.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not cm.checkfield(tp) or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return false end
	local chkf=PLAYER_NONE
	local mg1=e:GetHandler():GetOverlayGroup():Filter(cm.ffilter1,nil)
	local sg1=Duel.GetMatchingGroup(cm.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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