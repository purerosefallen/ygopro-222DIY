--★永遠の祭を作るアイドルもどき
function c114100502.initial_effect(c)
	--search
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(114000833)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,114100502)
	e2:SetCost(c114100502.spcost)
	e2:SetTarget(c114100502.sptg)
	e2:SetOperation(c114100502.spop)
	c:RegisterEffect(e2)
	if not c114100502.global_check then
		c114100502.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c114100502.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--counter count
function c114100502.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsSetCard(0x221) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,114100502,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,114100502,RESET_PHASE+PHASE_END,0,1) end
end
--end of count
function c114100502.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,114100502)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c114100502.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c114100502.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x221)
end

function c114100502.spfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c114100502.fdfilter(c,tp)
	return c:IsType(TYPE_FIELD) and ( c:GetActivateEffect():IsActivatable(tp) or c:IsAbleToHand() )
end
function c114100502.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local spcheck=0
	if chk==0 then 
		if Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil then
			return Duel.IsExistingMatchingCard(c114100502.fdfilter,tp,LOCATION_DECK,0,1,nil,tp) or ( Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c114100502.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) )
		else
			return Duel.IsExistingMatchingCard(c114100502.fdfilter,tp,LOCATION_DECK,0,1,nil,tp)
		end
	end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil then spcheck=1 end
	if spcheck==1 then 
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(0)
	end
end
function c114100502.spop(e,tp,eg,ep,ev,re,r,rp)
	local fdcheck=0
	if Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c114100502.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		local opt=Duel.SelectOption(tp,aux.Stringid(114100502,0),aux.Stringid(114100502,1))
		if opt==0 then
			fdcheck=1
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c114100502.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		end
	else
		fdcheck=1
	end
	if fdcheck==1 then
		local tc=Duel.SelectMatchingCard(tp,c114100502.fdfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
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
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		end
	end
end