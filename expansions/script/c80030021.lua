--N.玛丽苏
function c80030021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,80030021)
	e1:SetCost(c80030021.cost)
	e1:SetTarget(c80030021.target)
	e1:SetOperation(c80030021.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,80030022)
	e2:SetCondition(c80030021.spcon)
	e2:SetCost(c80030021.cost)
	e2:SetTarget(c80030021.target)
	e2:SetOperation(c80030021.activate1)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(80030021,ACTIVITY_SPSUMMON,c80030021.counterfilter)   
end
function c80030021.counterfilter(c)
	return c:IsSetCard(0x92d4)
end
function c80030021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80030021,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c80030021.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80030021.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x92d4)
end
function c80030021.filter(c)
	return c:IsSetCard(0x92d4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80030021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80030021.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function c80030021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80030021.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=Duel.GetOperatedGroup():GetFirst()
		local dg=Duel.GetMatchingGroup(c80030021.filter2,tp,0,LOCATION_ONFIELD,nil)
		if tc:GetLevel()==10 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80030021,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c80030021.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80030021.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local wtc=Duel.GetOperatedGroup():GetFirst()
		local dg1=Duel.GetMatchingGroup(c80030021.filter3,tp,0,LOCATION_ONFIELD,nil)
		if wtc:GetLevel()==10 and dg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80030021,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg1=dg1:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c80030021.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c80030021.filter3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
end
function c80030021.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) 
end