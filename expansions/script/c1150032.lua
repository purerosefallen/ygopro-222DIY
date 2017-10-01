--玫瑰花园
function c1150032.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150032+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1150032.con1)
	e1:SetCost(c1150032.cost1)
	e1:SetTarget(c1150032.tg1)
	e1:SetOperation(c1150032.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1150033)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c1150033.cost2)
	e2:SetTarget(c1150033.tg2)
	e2:SetOperation(c1150033.op2)
	c:RegisterEffect(e2)
--
end
--
function c1150032.cfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:GetLevel()>7 and c:IsSummonType(SUMMON_TYPE_ADVANCE) 
end
function c1150032.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1150032.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
--
function c1150032.costfilter1(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost()
end
function c1150032.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150032.costfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,c1150032.costfilter1,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
--
function c1150032.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1150034,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
--
function c1150032.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ct1+ct2>0 then 
		if Duel.IsPlayerCanSpecialSummonMonster(tp,1150034,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_FIRE) then
			local i=0
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then
				ct1=1
				ct2=1
			end
			for i=1,ct1 do
				local token=Duel.CreateToken(tp,1150034)
				if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
					local e1_1=Effect.CreateEffect(c)
					e1_1:SetType(EFFECT_TYPE_FIELD)
					e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1_1:SetRange(LOCATION_MZONE)
					e1_1:SetTarget(c1150034.splimit1_1)
					e1_1:SetCondition(c1150034.con1_1)
					e1_1:SetReset(RESET_EVENT+0x1fe0000)
					token:RegisterEffect(e1_1,true)
				end
			end
			for i=1,ct2 do
				local token=Duel.CreateToken(tp,1150034)
				if Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP) then
					local e1_1=Effect.CreateEffect(c)
					e1_1:SetType(EFFECT_TYPE_FIELD)
					e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1_1:SetRange(LOCATION_MZONE)
					e1_1:SetTarget(c1150034.splimit1_1)
					e1_1:SetCondition(c1150034.con1_1)
					e1_1:SetReset(RESET_EVENT+0x1fe0000)
					token:RegisterEffect(e1_1,true)
				end
			end
			Duel.SpecialSummonComplete()
		end
	end
end
--
function c1150032.splimit1_1(e,c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_LINK)
end
--
function c1150032.cfilter1_1(c)
	return c:IsFaceup() and c:IsCode(1150032)
end
function c1150032.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1150032.cfilter1_1,tp,LOCATION_ONFIELD,0,2,nil)
end
--
function c1150032.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
--
function c1150032.tfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c1150032.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c69584564.tfilter2(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c1150032.tfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1150032.tfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--
function c1150032.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--


