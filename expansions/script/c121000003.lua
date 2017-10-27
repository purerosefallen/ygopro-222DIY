--绯樱的剑士 雨时
function c121000003.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(0x14000)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c121000003.cost)
	e1:SetTarget(c121000003.target)
	e1:SetOperation(c121000003.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(c121000003.spcon)
	e2:SetTarget(c121000003.sptg)
	e2:SetOperation(c121000003.spop)
	c:RegisterEffect(e2)
end
function c121000003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c121000003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHANDE,nil,1,0,0)
end
function c121000003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c121000003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c121000003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,121000006,0,0x4011,1500,1500,3,RACE_SPELLCASTER,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c121000003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 and  Duel.GetMZoneCount(tp)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,121000006,0,0x4011,1500,1500,3,RACE_SPELLCASTER,ATTRIBUTE_WIND) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,121000006)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end