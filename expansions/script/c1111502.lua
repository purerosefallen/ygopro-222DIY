--灵都·幻想天地
function c1111502.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1111502,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1111502)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c1111502.con2)
	e2:SetTarget(c1111502.tg2)
	e2:SetOperation(c1111502.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1111502,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c1111502.cost3)
	e3:SetTarget(c1111502.tg3)
	e3:SetOperation(c1111502.op3)
	c:RegisterEffect(e3)   
end
--
c1111502.named_with_Ld=1
function c1111502.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1111502.confilter2(c)
	return c1111502.IsLd(c) and c:IsFaceup()
end
function c1111502.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1111502.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c1111502.filter2(c,e,tp)
	return c:GetLevel()==3 and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111502.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1111502.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1111502.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1111502.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetReset(RESET_PHASE+PHASE_END,2)
				e3:SetTargetRange(LOCATION_MZONE,0)
				e3:SetTarget(c1111502.tg5)
				e3:SetValue(c1111502.efilter)
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end
function c1111502.tgfilter2(c)
	return c:IsFaceup() and c1111502.IsLd(c) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c1111502.tg5(e,c)
	local g=Duel.GetMatchingGroup(c1111502.tgfilter2,c:GetControler(),LOCATION_MZONE,0,nil)
	return g
end
function c1111502.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
--
function c1111502.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c1111502.filter3(c)
	return c1111502.IsLd(c) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(c1111502)
end
function c1111502.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111502.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1111502.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1111502.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
