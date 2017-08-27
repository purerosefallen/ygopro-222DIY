--深层空想 死域之海
function c10122015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122015,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(c10122015.tkcost)
	e2:SetTarget(c10122015.tktg)
	e2:SetOperation(c10122015.tkop)
	c:RegisterEffect(e2)   
	--activate field spell
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122015,4))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c10122015.accon)
	e3:SetTarget(c10122015.actg) 
	e3:SetOperation(c10122015.acop)
	c:RegisterEffect(e3)	
end
function c10122015.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c10122015.acfilter(c,tp)
	return bit.band(c:GetType(),0x80002)==0x80002 and c:GetActivateEffect():IsActivatable(tp)
end
function c10122015.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122015.acfilter,tp,LOCATION_HAND,0,1,nil,tp) end
end
function c10122015.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c10122015.acfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
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
function c10122015.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122015.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10122015.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10122015.cfilter(c)
	return c:IsSetCard(0xc333) and c:IsAbleToDeckAsCost()
end
function c10122015.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c59255742.filter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()-1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c10122015.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10122015.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pe1=Effect.CreateEffect(c)
	pe1:SetType(EFFECT_TYPE_FIELD)
	pe1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	pe1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	pe1:SetReset(RESET_PHASE+PHASE_END)
	pe1:SetTargetRange(1,0)
	pe1:SetTarget(c10122015.splimit)
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
		e1:SetDescription(aux.Stringid(10122015,1))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(2)
		e1:SetValue(c10122015.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetDescription(aux.Stringid(10122015,2))
		e4:SetValue(1)
		token:RegisterEffect(e4,true)
		local e5=e4:Clone()
		e5:SetDescription(aux.Stringid(10122015,3))
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		token:RegisterEffect(e5,true)
	end
end
function c10122015.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c10122015.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_TOKEN)
end