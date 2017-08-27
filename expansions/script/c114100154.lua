--★新生の生贄　天魔･常世(とこよ)
function c114100154.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c114100154.tunefilter,c114100154.nontunefilter,2)
	c:EnableReviveLimit()
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c114100154.regcon)
	e1:SetOperation(c114100154.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c114100154.splimit)
	c:RegisterEffect(e2)
	--special summon other
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c114100154.condition)
	e3:SetTarget(c114100154.target)
	e3:SetOperation(c114100154.operation)
	c:RegisterEffect(e3)
	--before check
	if not c114100154.global_check then
		c114100154.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c114100154.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
--
function c114100154.tunefilter(c)
	return c:IsSetCard(0x221) and Duel.GetFlagEffect(c:GetControler(),114100154)==0
end
function c114100154.nontunefilter(c)
	return c:IsSetCard(0x221) and Duel.GetFlagEffect(c:GetControler(),114100154)==0 and c:IsNotTuner()
end
--
function c114100154.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsSetCard(0x221) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,114100154,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,114100154,RESET_PHASE+PHASE_END,0,1) end
end
--
function c114100154.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c114100154.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c114100154.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c114100154.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x221)
end
function c114100154.splimit(e,se,sp,st,spos,tgp)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)~=SUMMON_TYPE_SYNCHRO or Duel.GetFlagEffect(tgp,114100154)==0
end
--special other
function c114100154.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()~=SUMMON_TYPE_SYNCHRO then return false end
	if not c:IsSetCard(0x228) then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function c114100154.filter(c,code)
	return c:GetCode()~=code and c:IsSetCard(0x228) and ( c:IsFaceup() or not c:IsLocation(LOCATION_MZONE) ) and c:IsAbleToRemove()
end
function c114100154.spfilter(c,e,tp)
	return c:IsSetCard(0x228) and c:IsCanBeSpecialSummoned(e,88,tp,false,false)
end
function c114100154.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local code=c:GetCode()
	local rg=Duel.GetMatchingGroup(c114100154.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c,code)
	local class=rg:GetClassCount(Card.GetCode)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100154.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and c:IsAbleToRemove() and class>=7 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,8,tp,LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c114100154.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--check self
	if not c:IsRelateToEffect(e) then return end
	if not c:IsSetCard(0x228) or c:IsFacedown() then return end
	if c:GetSummonType()~=SUMMON_TYPE_SYNCHRO then return end
	if not c:IsAbleToRemove() then return end
	--check code*8
	local code=c:GetCode()
	local rg=Duel.GetMatchingGroup(c114100154.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c,code)
	local class=rg:GetClassCount(Card.GetCode)
	if class<=6 then return end
	--check sp summon target
	local spg=Duel.GetMatchingGroup(c114100154.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if spg:GetCount()==0 then return end
	--remove
	local tg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=rg:Select(tp,1,1,nil)
		rg:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		tg:Merge(sg)
	end
	tg:AddCard(c)
	--special summon
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==8 then
		Duel.SelectOption(tp,aux.Stringid(114100154,6))
		Duel.SelectOption(1-tp,aux.Stringid(114100154,6))
		Duel.SelectOption(tp,aux.Stringid(114100154,7))
		Duel.SelectOption(1-tp,aux.Stringid(114100154,7))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sptg=spg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sptg,88,tp,tp,false,false,POS_FACEUP)
	end
end