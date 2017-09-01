--Darkest　相似的我们
function c22231003.initial_effect(c)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,22231003)
	e3:SetTarget(c22231003.target)
	e3:SetOperation(c22231003.operation)
	c:RegisterEffect(e3)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,22231003)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c22231003.thcost)
	e2:SetTarget(c22231003.thtg)
	e2:SetOperation(c22231003.thop)
	c:RegisterEffect(e2)
end
c22231003.named_with_Darkest_D=1
function c22231003.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22231003.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true,POS_FACEDOWN_DEFENSE)
end
function c22231003.tgfilter(c,e,tp)
	local code=c:GetCode()
	return c22231003.IsDarkest(c) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsType(TYPE_FLIP) and Duel.IsExistingMatchingCard(c22231003.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,code)
end
function c22231003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and c23581825.tgfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22231003.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	local g=Duel.SelectTarget(tp,c22231003.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22231003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<1 then return false end
	local tc=Duel.GetFirstTarget()
	local co=tc:GetCode()
	local g=Duel.SelectMatchingCard(tp,c22231003.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,co)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEDOWN_DEFENSE)>0 then
			tc:CompleteProcedure()
			e:GetHandler():CancelToGrave()
			Duel.Overlay(tc,e:GetHandler())
			Duel.BreakEffect()
			local turnp=Duel.GetTurnPlayer()
			local tph=Duel.GetCurrentPhase()
			Duel.SkipPhase(turnp,tph,RESET_PHASE+PHASE_END,1)
		end
	end
end
function c22231003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22231003.hfilter(c)
	local code=c:GetCode()
	return c22231003.IsDarkest(c) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c22231003.thfilter,tp,LOCATION_DECK,0,1,nil,code)
end
function c22231003.thfilter(c,code)
	return c22231003.IsDarkest(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsCode(code)
end
function c22231003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22231003.hfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_DECK)
end
function c22231003.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,hg)
	local g=Duel.SelectMatchingCard(tp,c22231003.hfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local code=g:GetFirst():GetCode()
		local thg=Duel.GetMatchingGroup(c22231003.thfilter,tp,LOCATION_DECK,0,nil,code)
		if thg:GetCount()>0 then
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
end
