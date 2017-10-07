--B.E.S 厄运战舰
function c13257226.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(13257226,1))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(c13257226.otcon)
	e11:SetOperation(c13257226.otop)
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
	e1:SetTarget(c13257226.desreptg)
	e1:SetOperation(c13257226.desrepop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c13257226.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257226,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCondition(c13257226.descon)
	e4:SetCost(c13257226.descost)
	e4:SetOperation(c13257226.desop)
	c:RegisterEffect(e4)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_SUMMON_SUCCESS)
	e13:SetOperation(c13257226.bgmop)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e14)
	
end
function c13257226.otfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and (c:IsControler(tp) or c:IsFaceup())
end
function c13257226.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13257226.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c13257226.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13257226.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)
end
function c13257226.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
		and e:GetHandler():GetCounter(0x1f)>0 end
	return true
end
function c13257226.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x1f,1,REASON_EFFECT)
end
function c13257226.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1f,3)
end
function c13257226.descon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c13257226.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1f,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1f,1,REASON_COST)
end
function c13257226.desop(e,tp,eg,ep,ev,re,r,rp)
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
		if seq>0 then
			local lseq=seq-1
			local tc=nil
			if lseq==1 then
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
			elseif lseq==3 then
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
			end
			if tc and tc:IsControler(1-tp) then g:AddCard(tc)
			else
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-lseq)
				if tc then g:AddCard(tc)
				else 
					tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-lseq)
					if tc then g:AddCard(tc) end
				end
			end
		end
		if seq<4 then
			local rseq=seq+1
			local tc=nil
			if rseq==1 then
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
			elseif rseq==3 then
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
			end
			if tc and tc:IsControler(1-tp) then g:AddCard(tc)
			else
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-rseq)
				if tc then g:AddCard(tc)
				else 
					tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-rseq)
					if tc then g:AddCard(tc) end
				end
			end
		end
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c13257226.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257226,4))
end
