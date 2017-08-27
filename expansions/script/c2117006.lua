--谜言暗气
function c2117006.initial_effect(c)
	--copy spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2117006+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c2117006.cost)
	e1:SetOperation(c2117006.operation)
	c:RegisterEffect(e1)
end
function c2117006.cffilter(c)
	return c:IsRace(RACE_FIEND) and not c:IsPublic()
end
function c2117006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=e:GetLabelObject()
	if pg then pg:DeleteGroup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c2117006.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c2117006.cffilter,tp,LOCATION_HAND,0,1,99,e:GetHandler())
	g:KeepAlive()
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetCount())
	e:SetLabelObject(g)
end
function c2117006.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x21c)
end
function c2117006.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2117006.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Recover(tp,ct*800,REASON_EFFECT)
	local lg=e:GetLabelObject()
	if not lg then return end
	local tg=e:GetLabelObject():Filter(c2117006.filter1,nil)
	local mg=Duel.GetMatchingGroup(c2117006.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	if tg:GetCount()>0 and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(2117006,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:Select(tp,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end