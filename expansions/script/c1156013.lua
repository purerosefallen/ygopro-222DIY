--小小的甜蜜毒药
function c1156013.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156013.lkcheck,2,2)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c1156013.splimit0)
	c:RegisterEffect(e0)  
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetDescription(aux.Stringid(1156013,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c1156013.op2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c1156013.tg1)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e1)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c1156013.val4)
	c:RegisterEffect(e4)
--
end
--
function c1156013.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsRace(RACE_PLANT) 
end
--
function c1156013.splimit0(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
--
function c1156013.tg1(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsCode(1156013)
end
--
function c1156013.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(1156014,RESET_EVENT+0x1fe0000,0,1)
	local num=c:GetFlagEffect(1156014)
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_UPDATE_ATTACK)
	e2_1:SetValue(-num*300)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2_1)
	Duel.BreakEffect()
	if c:GetAttack()==0 then
		Duel.NegateRelatedChain(c,RESET_TURN_SET)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetCode(EFFECT_DISABLE)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2_2)
		local e2_3=Effect.CreateEffect(c)
		e2_3:SetType(EFFECT_TYPE_SINGLE)
		e2_3:SetCode(EFFECT_DISABLE_EFFECT)
		e2_3:SetValue(RESET_TURN_SET)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2_3)
		if Duel.Destroy(c,REASON_EFFECT)~=0 then
			Duel.Recover(c:GetOwner(),c:GetBaseAttack(),REASON_EFFECT)
		end
	end
end
--
function c1156013.val4(e,te)
	return te:IsActiveType(TYPE_MONSTER) and (c:GetFlagEffect(1156014)~=0 or c:IsStatus(STATUS_SPSUMMON_TURN))
end
--
