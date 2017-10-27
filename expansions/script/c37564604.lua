--Prim-恋爱的宇宙战争!!
local m=37564604
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prim=true
function cm.initial_effect(c)
	--Senya.setreg(c,m,37564600)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Senya.PrimSynchroFilter),1)
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34834619,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1,37564699)
	e1:SetCost(Senya.DiscardHandCost(1))
	e1:SetCondition(cm.thcon1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc and Senya.check_set_prim(tc) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function cm.filter(c)
	return c:IsFaceup() and not (c:GetAttack()==0 and c:IsDisabled())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
		tc=g:GetNext()
	end
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.mtfilter(c,e)
	return c:GetLevel()>0 and Senya.check_set_prim(c) and c:IsAbleToDeckAsCost() and not c:IsImmuneToEffect(e) and not c:IsCode(37564604)
end
function cm.spfilter(c,e,tp,m)
	return c:IsCode(37564604) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and m:CheckWithSumEqual(Card.GetRitualLevel,6,1,99,c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetMZoneCount(tp)<=0 then return false end
		local mg=Duel.GetMatchingGroup(cm.mtfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
		return cm.spfilter(e:GetHandler(),e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.mtfilter,tp,LOCATION_GRAVE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,6,1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoDeck(mat,nil,2,REASON_COST)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end