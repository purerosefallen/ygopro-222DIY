--天夜 聚能冲击·以太之力
function c60150621.initial_effect(c)
	c:SetUniqueOnField(1,0,60150621)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150621.ffilter,aux.FilterBoolFunction(c60150621.ffilter2),false)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c60150621.splimit)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150621,0))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(c60150621.seqcon)
	e3:SetOperation(c60150621.seqop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150621,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c60150621.condition)
	e4:SetCost(c60150621.cost)
	e4:SetOperation(c60150621.activate)
	c:RegisterEffect(e4)
end
function c60150621.ffilter(c)
	return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER)
end
function c60150621.ffilter2(c)
	return c:IsSetCard(0x3b21) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150621.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150621.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c60150621.seqop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.bor(flag,bit.lshift(0x1,seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.bor(flag,bit.lshift(0x1,seq+1)) end
		flag=bit.bxor(flag,0xff)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		if Duel.MoveSequence(e:GetHandler(),nseq)~=0 then
			local c=e:GetHandler()
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCode(EFFECT_IMMUNE_EFFECT)
			e5:SetValue(1)
			e5:SetReset(RESET_PHASE+RESET_CHAIN)
			c:RegisterEffect(e5)
		end
	end
end
function c60150621.condition(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) or Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
end
function c60150621.cfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150621.gfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150621.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
	and Duel.IsExistingMatchingCard(c60150621.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60150621.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local g2=g:Filter(c60150621.gfilter,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150618,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150618,1))
			local sg=g2:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoExtraP(sg,nil,REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150642,2))
			local sg=g:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoDeck(sg,nil,2,REASON_COST)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c60150621.activate(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local seq=e:GetHandler():GetSequence()
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,3-seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,3-seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5-seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5-seq)
		if tc then g:AddCard(tc) end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end