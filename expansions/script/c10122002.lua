--空想星界 幽暗密林
function c10122002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122002,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10122002.tktg)
	e2:SetOperation(c10122002.tkop)
	c:RegisterEffect(e2) 
end
function c10122002.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return tp~=Duel.GetTurnPlayer() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10122002.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,10122011)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetDescription(aux.Stringid(10122002,3))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(ac:GetAttack())
		e2:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e2,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetDescription(aux.Stringid(10122002,5))
		token:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetDescription(aux.Stringid(10122002,6))
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		token:RegisterEffect(e5,true)
	end
end