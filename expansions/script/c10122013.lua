--深层空想 恶魂之冢
function c10122013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122013,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10122013.tkcon)
	e2:SetTarget(c10122013.tktg)
	e2:SetOperation(c10122013.tkop)
	c:RegisterEffect(e2)
	--activate field spell
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122013,4))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c10122013.accon)
	e3:SetTarget(c10122013.actg) 
	e3:SetOperation(c10122013.acop)
	c:RegisterEffect(e3) 
end
function c10122013.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c10122013.acfilter(c,tp)
	return bit.band(c:GetType(),0x80002)==0x80002 and c:GetActivateEffect():IsActivatable(tp)
end
function c10122013.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122013.acfilter,tp,LOCATION_HAND,0,1,nil,tp) end
end
function c10122013.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c10122013.acfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c10122013.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c10122013.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10122013.cfilter,1,nil,tp)
end
function c10122013.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c59255742.filter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()-1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c10122013.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10122013.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetReset(RESET_PHASE+PHASE_END)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(c10122013.splimit)
	Duel.RegisterEffect(pe1,tp)
	local pe2=pe1:Clone()
	pe2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(pe2,tp)
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,10122011)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetDescription(aux.Stringid(10122013,1))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1)
		e1:SetValue(c10122013.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetDescription(aux.Stringid(10122013,2))
		e4:SetValue(1)
		token:RegisterEffect(e4,true)
		local e5=e4:Clone()
		e5:SetDescription(aux.Stringid(10122013,3))
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		token:RegisterEffect(e5,true)
	end
end
function c10122013.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c10122013.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_TOKEN)
end