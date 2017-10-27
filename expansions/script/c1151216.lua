--红蝙蝠『吸血鬼之夜』
function c1151216.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151216+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1151216.cost1)
	e1:SetCondition(c1151216.con1)
	e1:SetTarget(c1151216.tg1)
	e1:SetOperation(c1151216.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1151222)
	e2:SetCost(c1151216.cost2)
	e2:SetTarget(c1151216.tg2)
	e2:SetOperation(c1151216.op2)
	c:RegisterEffect(e2)
--
	Duel.AddCustomActivityCounter(1151216,ACTIVITY_SUMMON,c1151216.counterfilter)   
end
--
function c1151216.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
c1151216.named_with_Leisp=1
function c1151216.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151216.counterfilter(c)
	return c1151216.IsLeimi(c)
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
	if chk==0 then return Duel.CheckLPCost(tp,1200) and Duel.GetCustomActivityCount(1151216,tp,ACTIVITY_SUMMON)==0 end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetCode(EFFECT_CANNOT_SUMMON)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1151216.splimit1_1)
	Duel.RegisterEffect(e1_1,tp)
	Duel.PayLPCost(tp,1200)
end
function c1151216.splimit1_1(e,c)
	return not c1151216.IsLeimi(c)
end
--
function c1151216.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151998,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--
function c1151216.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151998,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
		local ft=2
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			ft=1
		end
		for i=1,ft do
			if Duel.GetMZoneCount(tp)>0 then
				local token=Duel.CreateToken(tp,1151998)
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
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1151216.tfilter2(c)
	return c:IsRace(RACE_FIEND)
end
function c1151216.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.CheckReleaseGroup(tp,c1151216.tfilter2,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,0)
end
--
function c1151216.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c1151216.tfilter2,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Release(g,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.BreakEffect()
			local e2_1=Effect.CreateEffect(e:GetHandler())
			e2_1:SetType(EFFECT_TYPE_FIELD)
			e2_1:SetCode(EFFECT_REFLECT_DAMAGE)
			e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2_1:SetTargetRange(1,0)
			e2_1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2_1,tp)
		end
	end
end




