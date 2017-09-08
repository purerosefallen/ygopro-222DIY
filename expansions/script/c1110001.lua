--灵都少女·蓿
function c1110001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1110001)
	e1:SetCost(c1110001.cost1)
	e1:SetTarget(c1110001.tg1)
	e1:SetOperation(c1110001.op1)
	c:RegisterEffect(e1)
--   
end
--
c1110001.named_with_Ld=1
function c1110001.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckLPCost(tp,800) and Duel.SelectYesNo(tp,aux.Stringid(1110001,1)) then
		Duel.PayLPCost(tp,800)
		e:SetLabel(1)
	end
end
--
function c1110001.filter1(c)
	return c:IsCode(1110002) and c:IsAbleToHand() and c:IsFaceup()
end
function c1110001.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1110001.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1110001.filter1,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1110001.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_HAND)
	if e:GetLabel() and e:GetLabel()==1 then
	   Duel.SetChainLimit(c1110001.limit1)
	end
end
function c1110001.limit1(e,ep,tp)
	return tp==ep
end
--
function c1110001.ofilter1(c)
	return c:IsCode(1111001) and c:IsSSetable()
end
function c1110001.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			local c=e:GetHandler()
			if c:IsRelateToEffect(e) then
				if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
					Duel.BreakEffect()
					local g=Duel.GetMatchingGroup(c1110001.ofilter1,tp,LOCATION_DECK,0,nil)  
					if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(1110001,0)) then  
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
						local g2=Duel.SelectMatchingCard(tp,c1110001.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
						if g2:GetCount()>0 then
							if Duel.SSet(tp,g2)~=0 then
								Duel.ConfirmCards(1-tp,g2)
								Duel.Damage(tp,200,REASON_EFFECT)
							end
						end
					end
				end
			end
		end
	end
end