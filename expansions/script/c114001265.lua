--ダークオーブ　－愛の塊（かたまり）－
function c114001265.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)
	e1:SetCountLimit(1,114001265+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c114001265.cost)
	e1:SetTarget(c114001265.target)
	e1:SetOperation(c114001265.operation)
	c:RegisterEffect(e1)
end
--sp summon function
function c114001265.mjfilter(c)
	return c:IsSetCard(0x223) or c:IsSetCard(0x224) 
		or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
		or c:IsCode(32751480) or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(17720747) or c:IsCode(98358303) or c:IsCode(91584698) --0x224
end
function c114001265.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c114001265.mjfilter(c) and c:IsLevelAbove(7)
end
function c114001265.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114001265.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114001265.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c114001265.filter(c,e,tp)
	return c:IsSetCard(0xcabb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(7)
end
function c114001265.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114001265.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end

function c114001265.retfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c114001265.mjfilter(c)
end
function c114001265.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114001265.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,505,tp,tp,false,false,POS_FACEUP)
		--return to hand
		--local retg=Duel.GetMatchingGroup(c114001265.retfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		--if retg:GetCount()>0 then
		--	if Duel.SelectYesNo(tp,aux.Stringid(114001265,0)) then
		--		local retsg=Duel.SelectMatchingCard(tp,c114001265.retfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		--		Duel.BreakEffect()
		--		Duel.HintSelection(retsg)
		--		Duel.SendtoHand(retsg,nil,REASON_EFFECT)
		--		Duel.ConfirmCards(1-tp,retsg)
		--	end
		--end
	end
end