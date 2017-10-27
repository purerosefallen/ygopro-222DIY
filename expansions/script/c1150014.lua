--佳奈美·夏洛特
function c1150014.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c1150014.tg1)
	e1:SetOperation(c1150014.op1)
	c:RegisterEffect(e1) 
-- 
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,1150014)
	e2:SetTarget(c1150014.tg2)
	e2:SetOperation(c1150014.op2)
	c:RegisterEffect(e2)
end
--
function c1150014.filter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c1150014.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150014.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1150014.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1150014.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c1150014.filter2(c,e,tp)
	return c:IsType(TYPE_EQUIP) and c:IsFaceup()
end
function c1150014.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150014.filter2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1150014.ofilter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
--
function c1150014.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(c1150014.ofilter2,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1150014,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c1150014.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end




