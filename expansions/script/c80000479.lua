--通往神殿的阶梯
function c80000479.initial_effect(c)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000479,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c80000479.hncost)
	e3:SetTarget(c80000479.target)
	e3:SetOperation(c80000479.operation)
	c:RegisterEffect(e3)	
end
function c80000479.spfilter1(c,e,tp)
	return c:IsCode(80000445) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and Duel.IsExistingMatchingCard(c80000479.spfilter2,tp,LOCATION_EXTRA,0,1,c,e,tp)
end
function c80000479.spfilter2(c,e,tp)
	return c:IsCode(80000446) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c80000479.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c80000479.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000479.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c80000479.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c80000479.spfilter2,tp,LOCATION_EXTRA,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		g1:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c80000479.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c80000479.cfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and mg:IsExists(c80000479.cfilter1,1,nil,mg,ft+1) end
	local g=Group.FromCards(c)
	ft=ft+1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc1=mg:FilterSelect(tp,c80000479.cfilter1,1,1,nil,mg,ft):GetFirst()
	g:AddCard(rc1)
	mg:RemoveCard(rc1)
	if rc1:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc2=mg:FilterSelect(tp,c80000479.cfilter2,1,1,nil,mg,ft):GetFirst()
	g:AddCard(rc2)
	mg:RemoveCard(rc2)
	if rc2:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc3=mg:FilterSelect(tp,c80000479.cfilter3,1,1,nil,mg,ft):GetFirst()
	g:AddCard(rc3)
	mg:RemoveCard(rc3)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80000479.cfilter1(c,g,ft)
	local mg=g:Clone()
	mg:RemoveCard(c)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	return c:IsCode(80000450) and mg:IsExists(c80000479.cfilter2,1,nil,mg,ft)
end
function c80000479.cfilter2(c,g,ft)
	local mg=g:Clone()
	mg:RemoveCard(c)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	return c:IsCode(80000451) and mg:IsExists(c80000479.cfilter3,1,nil,mg,ft)
end
function c80000479.cfilter3(c,g,ft)
	local mg=g:Clone()
	mg:RemoveCard(c)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	return c:IsCode(80000452) and ft>0
end