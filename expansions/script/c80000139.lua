--口袋妖怪 Mega艾路雷朵
function c80000139.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000) 
	--spsummon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.FALSE)
	c:RegisterEffect(e7) 
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c80000139.aclimit)
	e3:SetCondition(c80000139.actcon)
	c:RegisterEffect(e3)
	--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c80000139.accon)
	e2:SetValue(c80000139.efilter)
	c:RegisterEffect(e2)	 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,80000139+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80000139.target)
	e1:SetOperation(c80000139.activate)
	c:RegisterEffect(e1)
end
function c80000139.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c80000139.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c80000139.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000139.accon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c80000139.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c80000139.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=71 
	local tg=e:GetHandler():GetBaseAttack()
		Duel.SelectOption(tp,aux.Stringid(80000139,0))
		Duel.SelectOption(1-tp,aux.Stringid(80000139,0))
	while count>0 and Duel.IsPlayerCanDiscardDeck(tp,1) do
		if count<71 then Duel.BreakEffect() end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if tc:IsSetCard(0x2d0) or tc:IsSetCard(0x2d2)  then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)
			if tc:IsLocation(LOCATION_GRAVE) then
				Duel.Damage(tp,3700,REASON_EFFECT)
				Duel.Damage(1-tp,3700,REASON_EFFECT)
				count=count-1
			else count=0 end
		else
			count=0
		end
end
		if Duel.GetLP(1-tp)>0 then  
		Duel.SelectOption(tp,aux.Stringid(80000139,3))
		Duel.SelectOption(1-tp,aux.Stringid(80000139,4))
		elseif Duel.GetLP(1-tp)<=0 then 
		Duel.SelectOption(1-tp,aux.Stringid(80000139,1))
		Duel.SelectOption(tp,aux.Stringid(80000139,2))
end
end