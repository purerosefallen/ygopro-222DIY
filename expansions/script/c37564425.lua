--Prism-Duo
local m=37564425
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(function(e,c)
		return Senya.CheckPrism(c)
	end)
	e2:SetTargetRange(0xff,0xff)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.limcon)
	e1:SetOperation(cm.limop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(cm.limop2)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.chcon)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
end
function cm.sfilter(c,e,tp)
	return Senya.CheckPrism(c) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TO_HAND)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.limfilter(c,tp)
	return c:GetSummonPlayer()==tp and Senya.CheckPrism(c)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.limfilter,1,nil,tp)
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	local rc=re:GetHandler()
	return loc==LOCATION_HAND and np==tp and Senya.CheckPrism(rc)
end
function cm.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(rp)>0
		and re:GetHandler():IsCanBeSpecialSummoned(re,0,rp,false,false) and not re:GetHandler():IsLocation(LOCATION_MZONE) end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
		e:GetHandler():RegisterFlagEffect(37564499,RESET_EVENT+0x1fe0000,0,1)
		Duel.SpecialSummonComplete()
	end
end