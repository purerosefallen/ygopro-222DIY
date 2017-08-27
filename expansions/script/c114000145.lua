--★希望を伝える魔女っ子 アルス
function c114000145.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(114000145,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c114000145.target)
	e1:SetOperation(c114000145.operation)
	c:RegisterEffect(e1)
end

function c114000145.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(4) 
	and ( c:IsSetCard(0xcabb) or c:IsSetCard(0x223) or c:IsSetCard(0x224) 
	or c:IsCode(36405256) or c:IsCode(54360049) or c:IsCode(37160778) or c:IsCode(27491571) or c:IsCode(80741828) or c:IsCode(90330453) --0x223
	or c:IsCode(78010363) or c:IsCode(39432962) or c:IsCode(67511500) or c:IsCode(62379337) or c:IsCode(23087070) or c:IsCode(98358303) or c:IsCode(17720747) or c:IsCode(32751480) or c:IsCode(91584698) ) --0x224 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114000145.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c114000145.spfilter,tp,LOCATION_HAND,0,1,nil,4,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c114000145.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local slv=4
	local sg=Duel.GetMatchingGroup(c114000145.spfilter,tp,LOCATION_HAND,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		slv=slv-tc:GetLevel()
		Duel.SpecialSummonStep(tc,351,tp,tp,false,false,POS_FACEUP)
		sg:Remove(Card.IsLevelAbove,nil,slv+1)
		ft=ft-1
	until ft<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(114000145,1))
	Duel.SpecialSummonComplete()
end