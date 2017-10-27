--冬日的约会
function c1150037.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1150037+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1150037.con1)
	e1:SetOperation(c1150037.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1150038)
	e2:SetCondition(c1150037.con2)
	e2:SetCost(c1150037.cost2)
	e2:SetTarget(c1150037.tg2)
	e2:SetOperation(c1150037.op2)
	c:RegisterEffect(e2)
end
--
function c1150037.cfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<5
end
function c1150037.con1(e,c,og)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c1150037.cfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsFaceup() and not c:IsDisabled() and Duel.GetMZoneCount(tp)>0
end
--
function c1150037.op1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1150037.cfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local num=tc:GetLevel()
	if c:IsFaceup() then
		while num>0 do
			c:RegisterFlagEffect(1150037,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			num=num-1
		end
	end
	sg:Merge(g)
end
--
function c1150037.con2(e,c)
	return e:GetHandler():GetFlagEffect(1150037)~=0 and e:GetHandler():IsType(TYPE_SPELL) and Duel.GetMZoneCount(tp)>0
end
--
function c1150037.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
--
function c1150037.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetMZoneCount(tp)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,1150037,0,0x11,0,0,3,RACE_AQUA,ATTRIBUTE_WATER) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--
function c1150037.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,1150037,0,0x11,0,0,3,RACE_AQUA,ATTRIBUTE_WATER) then
			c:AddMonsterAttribute(TYPE_NORMAL)
			Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
			c:AddMonsterAttributeComplete()
			Duel.SpecialSummonComplete()
		end
	end
end
--

