--神鬼『蕾米莉亚潜行者』
function c1151217.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,1151217+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1151217.con1)
	e1:SetTarget(c1151217.tg1)
	e1:SetOperation(c1151217.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1151218)
	e2:SetCost(c1151217.cost2)
	e2:SetCondition(c1151217.con2)
	e2:SetTarget(c1151217.tg2)
	e2:SetOperation(c1151217.op2)
	c:RegisterEffect(e2)
--
end
--
function c1151217.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151217.named_with_Leisp=1
function c1151217.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151217.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c1151217.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1151217.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1151217.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK)>0 end
end
--
function c1151217.op1(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsCode,nil,code)
	if tg:GetCount()>0 then
		local sel=Duel.SelectOption(tp,aux.Stringid(1151217,0),aux.Stringid(1151217,1))
		if sel==0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		else
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end 
	Duel.ShuffleHand(1-tp)
end
--
function c1151217.cfilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function c1151217.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c1151217.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1151217.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1151217.confilter2(c)
	return c1151217.IsLeimi(c) and c:IsFaceup()
end
function c1151217.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1151217.confilter2,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1151217.tfilter2(c,e,tp)
	return c1151217.IsLeimi(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1151217.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1151217.tfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
--
function c1151217.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1151217.tfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



