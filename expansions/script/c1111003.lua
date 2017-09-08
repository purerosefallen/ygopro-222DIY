--蝶舞·祝祈
function c1111003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111003.tg1)
	e1:SetOperation(c1111003.op1)
	c:RegisterEffect(e1)	
--
end
--
function c1111003.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
c1111003.named_with_Dw=1
function c1111003.IsDw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Dw
end
--
function c1111003.tfilter1(c)
	return c:IsCode(1110001) and c:IsFaceup() and c:IsAbleToHand()
end
function c1111003.tfilter1x1(c,e,tp)
	return c:IsCode(1110002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1111003.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111003.tfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1111003.tfilter1x1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1111003.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_MZONE)
end
--
function c1111003.ofilter1(c,e,tp)
	return c:IsCode(1110002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111003.ofilter1x1(c)
	return c1111003.IsLd(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c1111003.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c1111003.ofilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c1111003.ofilter1x1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111003,0))
					local g2=Duel.SelectMatchingCard(tp,c1111003.ofilter1x1,tp,LOCATION_DECK,0,1,1,nil)
					if g2:GetCount()>0 then
						local tc2=g2:GetFirst()
						Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					end
				end
			end
		end
	end
end



