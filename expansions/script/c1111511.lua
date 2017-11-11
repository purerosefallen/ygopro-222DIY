--交界·废弃洋馆
function c1111511.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111511.tg1)
	e1:SetOperation(c1111511.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(c1111511.val2)
	e2:SetCondition(c1111511.con2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(c1111511.tg3)
	e3:SetValue(c1111511.val3)
	c:RegisterEffect(e3)
--
end
--
function c1111511.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
--
function c1111511.ofilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SPIRIT) and c:GetLevel()<4 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c1111511.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c1111511.ofilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111511,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1111511.tfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		end
	end
end
--
function c1111511.val2(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
--
function c1111511.con2(e,tp)
	local num=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1111)
	return num>2
end
--
function c11111511.tfilter3(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsAbleToHand()
end
function c1111511.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_SPIRIT) and eg:IsExists(c1111511.tfilter3,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(1111511,1)) then
		local g=eg:Filter(c1111511.tfilter3,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,ct,nil)
		end
		local tc=g:GetFirst()
		while tc do
			local e3_1=Effect.CreateEffect(e:GetHandler())
			e3_1:SetType(EFFECT_TYPE_SINGLE)
			e3_1:SetCode(EFFECT_TO_DECK_REDIRECT)
			e3_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3_1:SetValue(LOCATION_HAND)
			e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3_1)
			tc:RegisterFlagEffect(1111511,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3_2:SetCode(EVENT_TO_HAND)
		e3_2:SetCountLimit(1)
		e3_2:SetCondition(c1111511.con3_2)
		e3_2:SetOperation(c1111511.op3_2)
		e3_2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3_2,tp)
		return true
		else return false 
	end
end
function c1111511.cfilter3_2(c)
	return c:GetFlagEffect(1111511)~=0
end
function c1111511.con3_2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111511.cfilter3_2,1,nil)
end
function c1111511.op3_2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1111511.cfilter3_2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
--
function c1111511.val3(e,c)
	return false
end
--
