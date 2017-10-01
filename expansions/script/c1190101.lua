--ELF·水晶公主·缇娅
function c1190101.initial_effect(c)
--
	aux.AddSynchroProcedure(c,c1190101.syfilter1,c1190101.syfilter2,1)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1190101)
	e1:SetCondition(c1190101.con1)
	e1:SetTarget(c1190101.tg1)
	e1:SetOperation(c1190101.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1190101.con2)
	e2:SetCost(c1190101.cost2)
	e2:SetTarget(c1190101.tg2)
	e2:SetOperation(c1190101.op2)
	c:RegisterEffect(e2) 
end
--
c1190101.named_with_ELF=1
function c1190101.IsELF(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ELF
end
--
function c1190101.syfilter1(c)
	return c1190101.IsELF(c) and c:IsType(TYPE_TUNER)
end
function c1190101.syfilter2(c)
	return c1190101.IsELF(c) and c:IsType(TYPE_MONSTER)
end
--
function c1190101.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
--
function c1190101.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1190901,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c1190101.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1190901,0,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,1190901)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end
--
function c1190101.con2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c1190101.filter2(c)
	return c:IsCode(1190901) and c:IsReleasable()
end
function c1190101.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1190101.filter2,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c1190101.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c1190101.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c1190101.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
