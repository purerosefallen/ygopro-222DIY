--★思念（しねん）体★チャリオット
function c114100066.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,114100066)
	e1:SetCost(c114100066.spcost)
	e1:SetTarget(c114100066.sptg)
	e1:SetOperation(c114100066.spop)
	c:RegisterEffect(e1)
	--local e2=e1:Clone()
	--e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	--c:RegisterEffect(e2)
	--local e3=e1:Clone()
	--e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e3)
	if not c114100066.global_check then
		c114100066.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c114100066.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--counter count
function c114100066.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not ( tc:IsRace(RACE_WARRIOR) and tc:IsAttribute(ATTRIBUTE_DARK) ) then --tc:IsSetCard(0x221)
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,114100066,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,114100066,RESET_PHASE+PHASE_END,0,1) end
end
--end of count
function c114100066.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,114100066)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c114100066.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c114100066.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not ( c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK) ) and e:GetLabelObject()~=se --not c:IsSetCard(0x221)
end
--end of cost
function c114100066.filter(c,e,tp)
	return c:GetLevel()==4 and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(114100066)
end
function c114100066.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114100066.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c114100066.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114100066.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		--local e3=Effect.CreateEffect(e:GetHandler())
		--e3:SetType(EFFECT_TYPE_SINGLE)
		--e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		--e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		--e3:SetValue(c114100066.limit)
		--e3:SetReset(RESET_EVENT+0x1fe0000)
		--tc:RegisterEffect(e3,true)
		--local e4=e3:Clone()
		--e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		--tc:RegisterEffect(e4,true)
		Duel.SpecialSummonComplete()
	end
end
function c114100066.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x221)
end