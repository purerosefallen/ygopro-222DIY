--百慕 窈窕名流·夏洛特
local m=37564423
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismDamageCheckRegister(c,false)
	Senya.PrismXyzProcedure(c,2,2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(Senya.RemoveOverlayCost(1))
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(Senya.RemoveOverlayCost(1))
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.tfilter(c,e,tp)
	return Senya.CheckPrism(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		local ct=1
		local exte={c:IsHasEffect(37564427)}
		for _,te in ipairs(exte) do
			if Duel.SelectEffectYesNo(tp,te:GetHandler()) then
				Duel.Hint(HINT_CARD,0,te:GetHandler():GetOriginalCode())
				ct=ct+1
			end
		end
		Duel.ConfirmDecktop(tp,ct)
		local ag=Duel.GetDecktopGroup(tp,ct)
		local val={0}
		for tc in aux.Next(ag) do
			val[1]=val[1]+tc:GetTextAttack()
			if tc.bm_check_operation and (not tc.bm_check_condition or tc.bm_check_condition(e,tp,eg,ep,ev,re,r,rp)) then
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				tc.bm_check_operation(e,tp,eg,ep,ev,re,r,rp,val)
			end
		end
		local sg=ag:Filter(cm.tfilter,nil,e,tp)
		if sg:GetCount()>0 and Duel.GetMZoneCount(tp)>=sg:GetCount() and not (sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			local cval=math.floor(val[1]/2)
			Duel.BreakEffect()
			Duel.Recover(tp,cval,REASON_EFFECT)
			Duel.Damage(1-tp,cval,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
end
function cm.filter(c,e,tp)
	return Senya.CheckPrism(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==3 and Duel.GetFlagEffect(tp,c:GetCode())==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		tc:RegisterFlagEffect(37564499,RESET_EVENT+0x1fe0000,0,1)
		Duel.RegisterFlagEffect(tp,tc:GetCode(),RESET_PHASE+PHASE_END,0,1)
		Duel.SpecialSummonComplete()
	end
end