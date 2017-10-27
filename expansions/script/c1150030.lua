--红金丝雀
function c1150030.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,1150030)
	e1:SetCost(c1150030.cost1)
	e1:SetTarget(c1150030.tg1)
	e1:SetOperation(c1150030.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1150031)
	e2:SetCondition(c1150030.con2)
	e2:SetTarget(c1150030.tg2)
	e2:SetOperation(c1150030.op2)
	c:RegisterEffect(e2)
--
end
--
function c1150030.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsAttribute(ATTRIBUTE_WIND) and c:GetLevel()<9
end
function c1150030.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150030.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1150030.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
--
function c1150030.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1150030.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CHANGE_CODE)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			e1_1:SetValue(e:GetLabel())
			c:RegisterEffect(e1_1)
		end
	end
end
--
function c1150030.con2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
--
function c1150030.tfilter2(c)
	return c:IsAbleToHand()
end
function c1150030.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150030.tfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c1150030.tfilter2,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_ONFIELD)
end
--
function c1150030.ofilter2(c)
	return c:GetLevel()<6 and c:IsRace(RACE_FAIRY)
end
function c1150030.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1150030.tfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			if Duel.IsExistingMatchingCard(c1150030.ofilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1150030,0)) then
				local g2=Duel.SelectMatchingCard(tp,c1150030.ofilter2,tp,LOCATION_DECK,0,1,1,nil)
				if g2:GetCount()>0 then
					Duel.SendtoHand(g2,nil,REASON_EFFECT)
				end
			end
		end
	end
end


