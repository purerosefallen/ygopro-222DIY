--蝶舞·并蒂
function c1111002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111002.tg1)
	e1:SetOperation(c1111002.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c1111002.cost2)
	e2:SetTarget(c1111002.tg2)
	e2:SetOperation(c1111002.op2)
	c:RegisterEffect(e2)
end
--
c1111002.named_with_Dw=1
function c1111002.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111002.tfilter1(c)
	return c:IsCode(1110001) and c:IsFaceup()
end
function c1111002.tfilter2(c)
	return c:IsCode(1110002) and c:IsFaceup()
end
function c1111002.tfilter1x1(c,e,tp)
	return c:IsCode(1110002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111002.tfilter1x2(c,e,tp)
	return c:IsCode(1110001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111002.tfilterx(c)
	return c:IsCode(1110001,1110002)
end
function c1111002.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return ((Duel.GetMatchingGroupCount(c1111002.tfilter1,tp,LOCATION_MZONE,0,nil)==1 and Duel.GetMatchingGroupCount(c1111002.tfilter2,tp,LOCATION_MZONE,0,nil)==0 and Duel.IsExistingMatchingCard(c1111002.tfilter1x1,tp,LOCATION_DECK,0,1,nil,e,tp)) or (Duel.GetMatchingGroupCount(c1111002.tfilter1,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetMatchingGroupCount(c1111002.tfilter2,tp,LOCATION_MZONE,0,nil)==1 and Duel.IsExistingMatchingCard(c1111002.tfilter1x2,tp,LOCATION_DECK,0,1,nil,e,tp))) end
	local g=Duel.GetMatchingGroup(c1111002.tfilterx,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	local code=tc:GetCode()
	e:SetLabel(code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c1111002.op1(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if code==1110001 and Duel.IsExistingMatchingCard(c1111002.tfilter1x1,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1111002.tfilter1x1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		if code==1110002 and Duel.IsExistingMatchingCard(c1111002.tfilter1x2,tp,LOCATION_DECK,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c1111002.tfilter1x2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
--
function c1111002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--
function c1111002.tfilter2x(c)
	return c:IsFaceup() and c:IsCode(1110001,1110002) and c:IsAbleToHand()
end
function c1111002.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111002.tfilter2x,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
--
function c1111002.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1111002.tfilter2x,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--