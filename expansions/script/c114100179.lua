--★異能殺し 天魔･宿儺
function c114100179.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x221),2)
	c:EnableReviveLimit()
	--atk/def 1400
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_CALCULATING)
	e1:SetCondition(c114100179.adcon)
	e1:SetOperation(c114100179.adop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c114100179.discon)
	e2:SetOperation(c114100179.disop)
	c:RegisterEffect(e2)
end
function c114100179.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function c114100179.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc==nil then return end
	if not tc:IsType(TYPE_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
		e1:SetValue(1400)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
		e2:SetValue(1400)
		c:RegisterEffect(e2)
	end
end
function c114100179.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_SYNCHRO then return false end
	local tgp,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local rc=re:GetHandler()
	if not re:IsActiveType(TYPE_MONSTER) then 
		if re:IsActiveType(TYPE_SPELL) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE)>=6 then 
			return Duel.IsChainDisablable(ev) 
		else
			return false
		end
	else
		if rc:IsLevelAbove(9) or rc:IsRankAbove(9) then return false end
		return Duel.IsChainDisablable(ev)
	end
end
function c114100179.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end