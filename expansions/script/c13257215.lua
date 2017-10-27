--巨大战舰 阿巴顿（D）
function c13257215.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(13257215,1))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(c13257215.otcon)
	e11:SetOperation(c13257215.otop)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e11)
	--cannot special summon
	local e12=Effect.CreateEffect(c)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_SPSUMMON_CONDITION)
	e12:SetValue(aux.FALSE)
	c:RegisterEffect(e12)
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c13257215.desreptg)
	e1:SetOperation(c13257215.desrepop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c13257215.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257215,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCondition(c13257215.rmcon)
	e4:SetCost(c13257215.rmcost)
	e4:SetOperation(c13257215.rmop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_REMOVE)
	e5:SetCondition(c13257215.spcon)
	e5:SetTarget(c13257215.sptg)
	e5:SetOperation(c13257215.spop)
	c:RegisterEffect(e5)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_SUMMON_SUCCESS)
	e13:SetOperation(c13257215.bgmop)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e14)
	
end
function c13257215.otfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and (c:IsControler(tp) or c:IsFaceup())
end
function c13257215.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13257215.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c13257215.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13257215.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)
end
function c13257215.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x1f)>0 end
	return true
end
function c13257215.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1f,1,REASON_EFFECT)
end
function c13257215.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1f,3)
end
function c13257215.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c13257215.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1f,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1f,1,REASON_COST)
end
function c13257215.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) then
		local seq=c:GetSequence()
		if seq<=4 then
			if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
				or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
				local flag=0
				if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
				if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
				flag=bit.bxor(flag,0xff)
				Duel.Hint(HINT_SELECTMSG,tp,571)
				local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
				local nseq=0
				if s==1 then nseq=0
				elseif s==2 then nseq=1
				elseif s==4 then nseq=2
				elseif s==8 then nseq=3
				else nseq=4 end
				Duel.MoveSequence(c,nseq)
			end
		end
		seq=c:GetSequence()
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
		if tc then g:AddCard(tc) end
		if seq==1 then
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
		elseif seq==3 then
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
		end
		if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
		if g:GetCount()>0 then
			Duel.BreakEffect()
			tc=g:GetFirst()
			while tc do
				if tc:IsFaceup() and not tc:IsDisabled() then
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e2)
				end
				tc=g:GetNext()
			end
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c13257215.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
end
function c13257215.spfilter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0x353) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257215.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13257215.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13257215.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257215.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13257215.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257215,4))
end
