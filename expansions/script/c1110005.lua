--命运·时计
function c1110005.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,1110005)
	e1:SetCondition(c1110005.con1)
	e1:SetTarget(c1110005.tg1)
	e1:SetOperation(c1110005.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1110055)
	e2:SetCost(c1110005.cost2)
	e2:SetTarget(c1110005.tg2)
	e2:SetOperation(c1110005.op2)
	c:RegisterEffect(e2)
--
end
--
c1110005.named_with_Ld=1
function c1110005.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110005.cfilter1(c)
	return c:IsFaceup() and c1110005.IsLd(c) and c:IsType(TYPE_FIELD)
end
function c1110005.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1110005.cfilter1,tp,LOCATION_FZONE,0,1,nil)
end
--
function c1110005.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110005.cfilter,tp,LOCATION_FZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1110005.ofilter1x1(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c1110005.ofilter1x2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1110005.ofilter1x0(c,mg)
	return mg:IsExists(c1110005.ofilter1x1,1,nil,c) and c1110005.IsLd(c)
end
function c1110005.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		Duel.BreakEffect()
		local mg=Duel.GetMatchingGroup(c1110005.ofilter1x2,tp,LOCATION_MZONE,0,nil,e:GetHandler())
		if mg:GetCount()>0 then
			local g=Duel.GetMatchingGroup(c1110005.ofilter1x0,tp,LOCATION_EXTRA,0,nil,mg)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,sg:GetFirst(),e:GetHandler())
			end
		else
			Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_RULE)
		end
	end
end
--
function c1110005.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c1110005.filter2(c)
	return (c:IsCode(1110001) or c:IsCode(1110002)) and c:IsAbleToHand()
end
function c1110005.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110005.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1110005.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1110005.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end