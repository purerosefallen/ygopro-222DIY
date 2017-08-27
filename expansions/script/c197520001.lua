--蹦跳 小鹿
function c197520001.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(197520001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+0x1c0,TIMING_STANDBY_PHASE+0x1c0)
	e1:SetCountLimit(1,197520099)
	e1:SetCost(c197520001.cost)
	e1:SetTarget(c197520001.target)
	e1:SetOperation(c197520001.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(197520001,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,197521001)
	e2:SetCondition(c197520001.condition)
	e2:SetCost(c197520001.cost1)
	e2:SetOperation(c197520001.oper1)
	c:RegisterEffect(e2)
	--sy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(197520001,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1c0)
	e3:SetTarget(c197520001.xyztg)
	e3:SetOperation(c197520001.xyzop)
	c:RegisterEffect(e3)
	--cannot be material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(c197520001.splimit)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
end
function c197520001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=4
end
function c197520001.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xf92)
end
function c197520001.cfilter(c)
	return c:IsSetCard(0xf92) and c:IsDiscardable()
end
function c197520001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c197520001.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c197520001.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end
function c197520001.filter(c,e,tp)
	return c:IsSetCard(0xf92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c197520001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c197520001.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c197520001.operation(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c197520001.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c197520001.filter1(c,e,tp)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER)
end
function c197520001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c197520001.filter1,tp,LOCATION_DECK,0,1,nil) end
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local flag=0 
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
	local nseq=0
	if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end  
function c197520001.oper1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c197520001.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
function c197520001.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c197520001.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c197520001.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c197520001.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c197520001.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) end
		local tg=g1:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
end