--并蒂的灵魂遐想
function c1110161.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c1110161.lfilter),2,2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1110161,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1110161)
	e1:SetTarget(c1110161.tg1)
	e1:SetOperation(c1110161.op1)
	c:RegisterEffect(e1)   
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,1110166)
	e2:SetCost(c1110161.cost2)
	e2:SetTarget(c1110161.tg2)
	e2:SetOperation(c1110161.op2)
	c:RegisterEffect(e2)
--
end
--
c1110161.named_with_Ld=1
function c1110161.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1110161.lfilter(c)
	return c:GetLevel()==3
end
--
function c1110161.tfilter1(c,g,e,tp,zone)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c1110161.tfilter1x1,0,LOCATION_GRAVE,0,1,nil,e,tp,zone,c) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
end
function c1110161.tfilter1x1(c,e,tp,zone,tc)
	return c:GetLevel()==tc:GetLevel() and c:GetCode()~=tc:GetCode() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c1110161.IsLd(c)
end
function c1110161.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone()
	local g=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1110161.tfilter1(chkc,g,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.IsExistingTarget(c1110161.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1110161,0))
	local g=Duel.SelectTarget(tp,c1110161.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
--
function c1110161.op1(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	if zone~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c1110161.tfilter1x1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone,tc)
			local tc2=sg:GetFirst()
			if tc2 then
				Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP,zone)
			end
		end
	end
end
--
function c1110161.cfilter2(c)
	return Duel.IsExistingMatchingCard(c1110161.cfilter2x1,0,LOCATION_DECK,0,1,nil,c) and c1110161.IsLd(c) and c:IsType(TYPE_MONSTER)
end
function c1110161.cfilter2x1(c,tc)
	return c:GetLevel()==tc:GetLevel() and c:GetCode()~=tc:GetCode() and c:IsAbleToHand() and c1110161.IsLd(c)
end
function c1110161.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110161.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c1110161.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(tc)
end
--
function c1110161.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
--
function c1110161.ofilter2x1(c,e)
	local lv=e:GetLabel()
	return c:GetLevel()==lv and c1110161.IsLd(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1110161.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then
		local tc=e:GetLabelObject()
		local lv=tc:GetLevel()
		e:SetLabel(lv)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1110161.ofilter2x1,tp,LOCATION_DECK,0,1,1,nil,e)
		local tc2=sg:GetFirst()
		if tc2 then
			Duel.SendtoHand(tc2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc2)
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_CANNOT_TRIGGER)
			e2_1:SetReset(RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e2_1)
		end
	end
end
--