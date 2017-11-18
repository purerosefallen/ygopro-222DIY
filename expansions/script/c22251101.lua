--深远的神之领域
function c22251101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,22251101+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22251101.activate)
	c:RegisterEffect(e1)
	if c22251101.counter==nil then
		c22251101.counter=true
		c22251101[0]=0
		c22251101[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c22251101.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(c22251101.addcount)
		Duel.RegisterEffect(e3,0)
	end
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22251101.cost)
	e2:SetTarget(c22251101.tg)
	e2:SetOperation(c22251101.op)
	c:RegisterEffect(e2)
end
c22251101.named_with_Riviera=1
function c22251101.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22251101.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c22251101[0]=0
	c22251101[1]=0
end
function c22251101.addcount(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	while c~=nil do
		local p=c:GetControler()
		if c22251101.IsRiviera(c) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then c22251101[p]=c22251101[p]+1 end
		c=eg:GetNext()
	end
end
function c22251101.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c22251101.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c22251101.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22251101)
	Duel.Draw(tp,c22251101[tp]*2,REASON_EFFECT)
end
function c22251101.costfilter(c)
	return c:IsCode(22251101) and c:IsAbleToDeckAsCost()
end
function c22251101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22251101.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>1 end
	local rg=g:RandomSelect(tp,2)
	Duel.SendtoDeck(rg,nil,1,REASON_COST)
end
function c22251101.setfilter(c,ignore)
	return c:IsCode(22251001,22252001) and c:IsSSetable(ignore)
end
function c22251101.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22251101.setfilter,tp,LOCATION_DECK,0,1,nil,false) end
end
function c22251101.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22251101.setfilter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end