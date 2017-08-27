--空想乌托邦 混沌之海
function c10122001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122001,0))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c10122001.tkcon)
	e2:SetTarget(c10122001.tktg)
	e2:SetOperation(c10122001.tkop)
	c:RegisterEffect(e2)   
end
function c10122001.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c10122001.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10122001.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,10122011)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetDescription(aux.Stringid(10122001,3))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1)
		e1:SetValue(c10122001.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetDescription(aux.Stringid(10122001,4))
		e2:SetValue(c10122001.valcon2)
		token:RegisterEffect(e2,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetDescription(aux.Stringid(10122001,5))
		e4:SetValue(1)
		token:RegisterEffect(e4,true)
		local e5=e4:Clone()
		e5:SetDescription(aux.Stringid(10122001,6))
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		token:RegisterEffect(e5,true)
	end
end
function c10122001.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c10122001.valcon2(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end