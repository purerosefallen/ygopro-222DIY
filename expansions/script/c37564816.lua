--3L·花在幻想的尽头
local m=37564816
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.CommonEffect_3L(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(Senya.ForbiddenCost(Senya.SelfReleaseCost))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.effect_operation_3L(c,ctlm)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(0x14000)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(ctlm)
	e3:SetCost(Senya.DescriptionCost())
	e3:SetCondition(cm.hdcon)
	e3:SetTarget(cm.hdtg)
	e3:SetOperation(cm.hdop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3,true)
	return e3
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function cm.filter2(c,e,tp,m,f,chkf,l)
	if not (c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Senya.check_set_3L(c)) then return false end
	local f=Duel.GetLocationCountFromEx
	if l==1 then
		Duel.GetLocationCountFromEx=cm.ReplaceLocationCount(f,e:GetHandler())		
	end
	local res=c:CheckFusionMaterial(m,nil,chkf)
	Duel.GetLocationCountFromEx=f
	return res
end
function cm.ReplaceLocationCount(f,ec)
	return function(tp,p,g,fc)
		if g:IsContains(ec) then return f(tp,p,g,fc) end
		g:AddCard(ec)
		local res=f(tp,p,g,fc)
		g:RemoveCard(ec)
		return res
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local l=e:GetLabel()
	e:SetLabel(0)
	if chk==0 then
		local chkf=tp
		local mg1=Senya.GetFusionMaterial(tp,LOCATION_REMOVED,nil,cm.filter0,nil)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,l)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,l)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Senya.GetFusionMaterial(tp,LOCATION_REMOVED,nil,cm.filter0,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.SendtoDeck(mat1,nil,0,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			for p=0,1 do
				if mat1:IsExists(cm.shfilter,1,nil,p) then Duel.ShuffleDeck(p) end
			end   
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
function cm.shfilter(c,p)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(p)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end