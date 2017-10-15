--3L·不可思议的国度
local m=37564848
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_3L=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.atkcon)
	e3:SetCost(cm.atkcost)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(e,c)
		return not Senya.check_set_3L(c)
	end)
	c:RegisterEffect(e2)]]
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.mfilter(c)
	return c:IsAbleToRemove() and Senya.check_set_3L(c)
end
function cm.flimit(tp,g,fc)
	return not g:IsExists(Senya.NOT(Senya.check_fusion_set_3L),1,nil)
end
function cm.fcheck(c,mg)
	aux.FCheckAdditional=cm.flimit
	local res=c:CheckFusionMaterial(mg,nil,PLAYER_NONE)
	aux.FCheckAdditional=nil
	return res
end

function cm.fselect(tp,tc,mg)
	aux.FCheckAdditional=cm.flimit
	local g=Duel.SelectFusionMaterial(tp,tc,mg,nil,PLAYER_NONE)
	aux.FCheckAdditional=nil
	return g
end
function cm.filter2(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and Senya.check_set_3L(c) and (not f or f(c)) and c:GetLevel()==7
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and cm.fcheck(c,m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCountFromEx(tp)<=0 then return false end
		local mg1=Senya.GetFusionMaterial(tp,LOCATION_DECK,nil,cm.mfilter,nil)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg1=Senya.GetFusionMaterial(tp,LOCATION_DECK,nil,cm.mfilter,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		tc:RegisterFlagEffect(m,RESET_CHAIN,0,1)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=cm.fselect(tp,tc,mg1)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			tc:ReplaceEffect(80316585,0x1fe1000,1)
			Duel.SpecialSummonComplete()
		else
			local mat2=cm.fselect(tp,tc,mg2,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		e:GetHandler():SetCardTarget(tc)
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFirstCardTarget()
end
function cm.cfilter(c)
	return Senya.check_set_3L(c) and c:IsDiscardable()
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.sfilter(c,tp,fc,e)
	if not fc then return false end
	if e and not c:IsCanBeEffectTarget(e) then return false end
	return c:IsControler(tp) and c:IsLocation(LOCATION_REMOVED) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and Senya.check_set_3L(c) and Senya.EffectSourceFilter_3L(c,fc) and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fc
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local fc=e:GetHandler():GetFirstCardTarget()
	if chkc then return fc and fc:GetMaterial():IsContains(chkc) and cm.sfilter(chkc,tp,fc) end
	if chk==0 then return fc and fc:GetMaterial():IsExists(cm.sfilter,1,nil,tp,fc,e) end
	local g=fc:GetMaterial():Filter(cm.sfilter,nil,tp,fc,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local fc=e:GetHandler():GetFirstCardTarget()
	if not fc or not tc or not tc:IsRelateToEffect(e) then return end
	Senya.GainEffect_3L(fc,tc)
	Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	if tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tc:GetControler()) end
end
