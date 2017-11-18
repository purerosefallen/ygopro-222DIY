--芙兰朵露·斯卡蕾特
function c1152101.initial_effect(c)
--
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c1152101.matfilter),1)
	c:EnableReviveLimit()
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c1152101.cost1)
	e1:SetOperation(c1152101.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c1152101.con4)
	e4:SetTarget(c1152101.tg4)
	e4:SetOperation(c1152101.op4)
	c:RegisterEffect(e4)
end
--
c1152101.named_with_Fulan=1
function c1152101.IsFulan(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulan
end
function c1152101.IsFulsp(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Fulsp
end
function c1152101.matfilter(c)
	return c1152101.IsFulan(c) and c:IsType(TYPE_MONSTER)
end
--
function c1152101.cfilter1(c)
	return c:IsAbleToGraveAsCost()
end
function c1152101.cost1(e,c,tp)
	return Duel.IsExistingMatchingCard(c1152101.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
--
function c1152101.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1152101.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--
function c1152101.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
--
function c1152101.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>3 and Duel.IsPlayerCanSpecialSummonMonster(tp,1152990,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
--
function c1152101.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1152990,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then
		for i=1,4 do
			local token=Duel.CreateToken(tp,1152990)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
--

