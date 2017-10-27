--ELF·精灵环绕
function c1191002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1191002,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1191002+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1191002.tg1)
	e1:SetOperation(c1191002.op1)
	c:RegisterEffect(e1)
--
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1191002,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,1191002+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c1191002.tg2)
	e2:SetOperation(c1191002.op2)
	c:RegisterEffect(e2)
--  
end
--
c1191002.named_with_ELF=1
function c1191002.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
--function c1191002.cfilter(c)
--  return c1191002.IsELF(c) and c:IsType(TYPE_MONSTER)
--end
function c1191002.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1191002.filter(c,e,tp)
	return c1191002.IsELF(c) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(1)-- and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c1191002.opfilter(c,e,tp)
	return c1191002.IsELF(c) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c1191002.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if c1191002.IsELF(tc) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetMZoneCount(tp)>0 then
--  Duel.DisableShuffleCheck()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
--
		if Duel.GetMZoneCount(tp)<=0 then return end
		local g3=Duel.GetMatchingGroup(c1191002.filter,tp,LOCATION_GRAVE,0,nil)
		if g3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1191002,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c1191002.opfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				local tc2=g2:GetFirst()
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		else if c1191002.IsELF(tc) and (tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP)) then
--  Duel.DisableShuffleCheck()
		Duel.Draw(tp,1,REASON_EFFECT)
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
--
--
function c1191002.filter2(c,e,tp)
	return c1191002.IsELF(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c1191002.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c1191002.filter2(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1191002.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1191002.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1191002.opfilter2(c,e,tp)
	return c1191002.IsELF(c) and c:IsAbleToGrave()
end
function c1191002.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
	Duel.Draw(tp,1,REASON_EFFECT)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)	
	local g=Duel.SelectMatchingCard(tp,c1191002.opfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_EFFECT)
end