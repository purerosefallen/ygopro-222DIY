--ELF·自然指引
function c1191003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,1191003+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1191003.tg1)
	e1:SetOperation(c1191003.op1)
	c:RegisterEffect(e1)   
--	
end
--
c1191003.named_with_ELF=1
function c1191003.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1191003.tfilter(c,tp)
	return c1191003.IsELF(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1191003.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1191003.filter2(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1191003.tfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1191003.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1191003.filter1(c)
	return c:IsCode(1190001) 
end
function c1191003.opfilter(c,e,tp)
	return c:IsCode(1190001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c1191003.op1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
	local dc=Duel.GetOperatedGroup():GetFirst()
	if Duel.GetMZoneCount(tp)<=0 then return end
	if c1191003.IsELF(dc) then
		local g3=Duel.GetMatchingGroup(c1191003.filter1,tp,LOCATION_DECK,0,nil)
		if g3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1191003,0)) then
		Duel.ConfirmCards(1-tp,dc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1191003.opfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

