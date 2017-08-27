--222 专用卡限定
function c80010049.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80010049,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80010049+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c80010049.condition)
	e1:SetCost(c80010049.spcost)
	e1:SetTarget(c80010049.sptg)
	e1:SetOperation(c80010049.spop)
	c:RegisterEffect(e1)	
end
function c80010049.condition(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	return t>s
end
function c80010049.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(3*Duel.GetLP(tp)/4))
end
function c80010049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(aux.FALSE)
end
function c80010049.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and c:IsCode(80006003)
end
function c80010049.filter2(c,e,tp)
	return c:IsCode(80006006) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c80010049.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsCode(80006003) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c80010049.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		end
	else
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_ONFIELD,0,nil,80006003)
	local hc=Duel.GetMatchingGroup(c80010049.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if gc>0 and Duel.SelectYesNo(tp,aux.Stringid(80010049,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(hc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	end
end