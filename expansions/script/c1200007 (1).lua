--LA Da'ath 智慧的拉結兒
function c1200007.initial_effect(c)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200007,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,1200007)
	e2:SetTarget(c1200007.sptg)
	e2:SetOperation(c1200007.spop)
	c:RegisterEffect(e2)
end
function c1200007.spfilter(c)
	return c:IsSetCard(0xfba) and c:IsFaceup() and c:IsAbleToHand()
end
function c1200007.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1200007.spfilter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsExistingTarget(c1200007.spfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1200007.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1200007.spthfilter(c)
	return c:IsSetCard(0xfbc) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c1200007.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) then
			if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
				if (tc:GetRace()==e:GetHandler():GetRace() or tc:GetAttribute()==e:GetHandler():GetAttribute()) and Duel.IsExistingMatchingCard(c1200007.spthfilter,tp,LOCATION_DECK,0,1,nil) then
					if Duel.SelectYesNo(tp,aux.Stringid(1200007,1)) then
					local g=Duel.SelectMatchingCard(tp,c1200007.spthfilter,tp,LOCATION_DECK,0,1,1,nil)
					if g:GetCount()>0 then
						Duel.SendtoHand(g,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g)
					end
					end
				end
			end
		end
	end
end





