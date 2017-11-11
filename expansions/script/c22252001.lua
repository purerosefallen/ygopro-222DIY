--神威再临
function c22252001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22252001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22252001.target)
	e1:SetOperation(c22252001.activate)
	c:RegisterEffect(e1)
	--ind
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22252001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22252001.cost)
	e2:SetOperation(c22252001.op)
	c:RegisterEffect(e2)
end
c22252001.named_with_Riviera=1
function c22252001.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22252001.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c22252001.IsRiviera(c)
end
function c22252001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22252001.filter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22252001.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22252001.filter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22252001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	if ct>0 and sg:FilterCount(Card.IsRace,nil,RACE_FAIRY)<2 and Duel.SelectYesNo(tp,aux.Stringid(22252001,2)) then
		local tc=sg:GetFirst()
		while tc do
			if not tc:IsRace(RACE_FAIRY) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetValue(RACE_FAIRY)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
			end
		tc=sg:GetNext()
		end
	end
end
function c22252001.costfilter(c)
	return c:IsCode(22252001) and c:IsAbleToDeckAsCost()
end
function c22252001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22252001.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>1 end
	local rg=g:RandomSelect(tp,2)
	Duel.SendtoDeck(rg,nil,1,REASON_COST)
end
function c22252001.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c22252001.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c22252001.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
