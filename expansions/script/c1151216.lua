--红蝙蝠『吸血鬼之夜』
function c1151216.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1151216.cost1)
	e1:SetCondition(c1151216.con1)
	e1:SetTarget(c1151216.tg1)
	e1:SetOperation(c1151216.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1151216.cost2)
	e2:SetTarget(c1151216.tg2)
	e2:SetOperation(c1151216.op2)
	c:RegisterEffect(e2)
--
	Duel.AddCustomActivityCounter(1151216,ACTIVITY_SUMMON,c1151216.counterfilter)   
	Duel.AddCustomActivityCounter(1151217,ACTIVITY_SPSUMMON,c1151216.counterfilter)   
--
end
--
function c1151216.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151216.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151216.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
end
--
function c1151216.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c1151216.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1151216.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1151216.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) and Duel.GetCustomActivityCount(1151216,tp,ACTIVITY_SUMMON)==0 and Duel.GetCustomActivityCount(1151217,tp,ACTIVITY_SPSUMMON)==0 end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetCode(EFFECT_CANNOT_SUMMON)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1151216.splimit1_1)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(e:GetHandler())
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_2:SetCode(EFFECT_CANNOT_SUMMON)
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	e1_2:SetTargetRange(1,0)
	e1_2:SetTarget(c1151216.splimit1_1)
	Duel.RegisterEffect(e1_2,tp)
	Duel.PayLPCost(tp,1200)
end
function c1151216.splimit1_1(e,c)
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND))
end
--
function c1151216.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151990,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1151216.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151990,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
		local ft=2
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			ft=1
		end
		for i=1,ft do
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				local token=Duel.CreateToken(tp,1151990)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		Duel.SpecialSummonComplete()
	end
end
--
function c1151216.cfilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function c1151216.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c1151216.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1151216.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e2_4=Effect.CreateEffect(tc)
	e2_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2_4:SetRange(LOCATION_REMOVED)
	e2_4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2_4:SetCountLimit(1)
	e2_4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	e2_4:SetCondition(c1151216.con2_4)
	e2_4:SetOperation(c1151216.op2_4)
	tc:RegisterEffect(e2_4)
end
function c1151216.con2_4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1151216.op2_4(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
--
function c1151216.tfilter2(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1151216.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1151216.tfilter2,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end
--
function c1151216.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c1151216.tfilter2,tp,LOCATION_SZONE,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e2_1=Effect.CreateEffect(tc)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_DISABLE)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1)
		local e2_2=Effect.CreateEffect(tc)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetCode(EFFECT_DISABLE_EFFECT)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_2)
		local e2_3=Effect.CreateEffect(tc)
		e2_3:SetType(EFFECT_TYPE_SINGLE)
		e2_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2_3:SetCode(EFFECT_CHANGE_CODE)
		e2_3:SetRange(LOCATION_MZONE)
		e2_3:SetValue(1151990)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_3)
		tc=g:GetNext()
	end
end
--
