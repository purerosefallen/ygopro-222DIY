--夏季的恶魔姐妹
function c1154005.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c1154005.lfilter),2)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c1154005.con1)
	e1:SetTarget(c1154005.tg1)
	e1:SetOperation(c1154005.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(aux.exccon)
	e3:SetTarget(c1154005.tg3)
	e3:SetOperation(c1154005.op3)
	c:RegisterEffect(e3)
--
end
--
function c1154005.lfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
--
function c1154005.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
--
function c1154005.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsLocation(LOCATION_MZONE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
--
function c1154005.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,1154006)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1_4=Effect.CreateEffect(token)
	e1_4:SetType(EFFECT_TYPE_SINGLE)
	e1_4:SetCode(EFFECT_CHANGE_TYPE)
	e1_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_4:SetValue(TYPE_EQUIP+TYPE_SPELL)
	e1_4:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1_4,true)
	local e1_5=Effect.CreateEffect(token)
	e1_5:SetType(EFFECT_TYPE_SINGLE)
	e1_5:SetCode(EFFECT_EQUIP_LIMIT)
	e1_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_5:SetValue(1)
	token:RegisterEffect(e1_5,true)
	token:CancelToGrave()
	if Duel.Equip(tp,token,e:GetHandler(),false) then
		local e1_1=Effect.CreateEffect(token)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_1:SetRange(LOCATION_ONFIELD)
		e1_1:SetValue(c1154006.efilter1_1)
		token:RegisterEffect(e1_1,true)
		local e1_2=Effect.CreateEffect(token)
		e1_2:SetType(EFFECT_TYPE_FIELD)
		e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e1_2:SetRange(LOCATION_ONFIELD)
		e1_2:SetTargetRange(1,0)
		e1_2:SetValue(c1154006.damval1_2)
		token:RegisterEffect(e1_2,true)
	else
		Duel.SendtoGrave(token,REASON_RULE)
	end
end
function c1154005.efilter1_1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c1154005.damval1_2(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
--
function c1154005.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER)
	if chk==0 then return np~=tp and re:IsActiveType(TYPE_MONSTER) end
end
--
function c1154005.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1154007,0,0x4011,0,0,1,RACE_AQUA,ATTRIBUTE_WATER) and Duel.SelectYesNo(tp,aux.Stringid(1154005,0)) then
		Duel.Hint(HINT_CARD,0,1154005)
		local token=Duel.CreateToken(tp,1154007)
		if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
			local e3_1=Effect.CreateEffect(e:GetHandler())
			e3_1:SetType(EFFECT_TYPE_SINGLE)
			e3_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3_1:SetRange(LOCATION_MZONE)
			e3_1:SetCode(EFFECT_IMMUNE_EFFECT)
			e3_1:SetValue(c1154005.efilter3_1)
			e3_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			e:GetHandler():RegisterEffect(e3_1,true)
		end
		local e3_2=Effect.CreateEffect(e:GetHandler())
		e3_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_2:SetType(EFFECT_TYPE_SINGLE)
		e3_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3_2:SetValue(1)
		if Duel.GetTurnPlayer()~=tp then
			e3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		else
			e3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		end
		e:GetHandler():RegisterEffect(e3_2,true)
	end
end
function c1154005.efilter3_1(e,te)
	return te:GetOwner()~=e:GetOwner()
end


