--伊始·梦蝶
function c1110006.initial_effect(c)
--
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110006,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1,1110006)
	e1:SetCost(c1110006.cost1)
	e1:SetTarget(c1110006.tg1)
	e1:SetOperation(c1110006.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1110056)
	e2:SetCost(c1110006.cost2)
	e2:SetTarget(c1110006.tg2)
	e2:SetOperation(c1110006.op2)
	c:RegisterEffect(e2)
--
end
--
c1110006.named_with_Ld=1
function c1110006.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
function c1110006.IsLq(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lq
end
--
function c1110006.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
--
function c1110006.tfilter1(c,e,tp)
	return c:IsCode(1110002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1110006.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1110006.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
--
function c1110006.ofilter1(c)
	return c:IsType(TYPE_CONTINUOUS) and c1110006.IsLd(c)
end
function c1110006.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1110006.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c1110006.ofilter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110006,0))
			local g2=Duel.SelectMatchingCard(tp,c1110006.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				local tc2=g2:GetFirst()
				Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
end
--
function c1110006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c1110006.tfilter2(c)
	return c:IsType(TYPE_CONTINUOUS) and c1110006.IsLq(c)
end
function c1110006.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110006.tfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
--
function c1110006.ofilter2(c)
	return c:GetOriginalCode(47355498) and not c:IsDisabled()
end
function c1110006.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsChainDisablable(0) and Duel.GetMatchingGroupCount(c1110006.ofilter2,tp,LOCATION_FZONE,LOCATION_FZONE,nil)>0 then
		Duel.NegateEffect(0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110006,0))
		local g=Duel.SelectMatchingCard(tp,c1110006.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then 
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end