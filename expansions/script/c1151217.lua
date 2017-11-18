--神鬼『蕾米莉亚潜行者』
function c1151217.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c1151217.con1)
	e1:SetTarget(c1151217.tg1)
	e1:SetOperation(c1151217.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
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
	return c1151217.IsLeimi(c) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1151217.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1151217.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1151217.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA+LOCATION_DECK)>0 end
end
--
function c1151217.op1(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetCode()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA+LOCATION_DECK)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsCode,nil,code)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	end 
end
--
function c1151217.cfilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
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
	return c:IsType(TYPE_MONSTER)
end
function c1151217.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1151217.confilter2,tp,LOCATION_ONFIELD,0,1,nil)
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
		local tc=g:GetFirst()
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e2_1=Effect.CreateEffect(tc)
			e2_1:SetType(EFFECT_TYPE_SINGLE)
			e2_1:SetCode(EFFECT_IMMUNE_EFFECT)
			e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2_1:SetRange(LOCATION_MZONE)
			e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2_1:SetValue(c1151217.efilter2_1)
			tc:RegisterEffect(e2_1,true)
		end
	end
end
function c1151217.efilter2_1(e,re)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
