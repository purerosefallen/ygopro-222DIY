--Mega Stone
function c80000060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(80000060,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMING_EQUIP+TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCost(c80000060.cost)
	e1:SetTarget(c80000060.target)
	e1:SetOperation(c80000060.activate)
	e1:SetCondition(c80000060.condition)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000060,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,80000060)
	e4:SetCost(c80000060.cost1)
	e4:SetTarget(c80000060.tg)
	e4:SetOperation(c80000060.op)
	c:RegisterEffect(e4) 
end
c80000060.list={[80000066]=80000067,[80000070]=80000071,[80000074]=80000075,
				[80000076]=80000077,[80000005]=80000078,[80000054]=80000079,
				[80000018]=80000080,[80000011]=80000085,[80000014]=80000086,
				[80000044]=80000087,[80000047]=80000088,[80000041]=80000089,
				[80000008]=80000083,[80000092]=80000093,[80000100]=80000101,
				[80000111]=80000123,[80000110]=80000137,[80000107]=80000138,
				[80000108]=80000139,[80000112]=80000140,[80000113]=80000141,
				[80000167]=80000168,[80000188]=80000189,[80000200]=80000201,
				[80000202]=80000203,[80000214]=80000215,[80000216]=80000217,
				[80000242]=80000244,[80000302]=80000303,[80000317]=80000318,
				[80000340]=80000341,[80000375]=80000376,[80000377]=80000378,
				[80000398]=80000399,[80000401]=80000402,[80000480]=80000481,
				[80000482]=80000483,[80000484]=80000485,[80000486]=80000487,
				[80000488]=80000489,[80000490]=80000491}
function c80000060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c80000060.cfilter(c)
	return c:IsFaceup() and c:IsCode(80000062)
end
function c80000060.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) 
	and  Duel.IsExistingMatchingCard(c80000060.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c80000060.filter1(c,e,tp)
	local code=c:GetCode()
	local tcode=c80000060.list[code]
	return tcode and c:IsSetCard(0x2d0) and Duel.IsExistingMatchingCard(c80000060.filter2,tp,LOCATION_EXTRA,0,1,nil,tcode,e,tp)
end
function c80000060.filter2(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c80000060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c80000060.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c80000060.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80000060.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local tcode=c80000060.list[code]
	local tc=Duel.GetFirstMatchingCard(c80000060.filter2,tp,LOCATION_EXTRA,0,nil,tcode,e,tp)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end 
function c80000060.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000060.filter(c)
	return c:GetCode()==80000062 and c:IsAbleToHand()
end
function c80000060.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000060.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000060.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c80000060.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end