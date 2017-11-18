--壮绝圣战
function c22251201.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22251201+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22251201.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c22251201.cost)
	e1:SetTarget(c22251201.target)
	e1:SetOperation(c22251201.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22251201)
	e2:SetCondition(c22251201.con)
	e2:SetCost(c22251201.cost2)
	e2:SetTarget(c22251201.tg)
	e2:SetOperation(c22251201.op)
	c:RegisterEffect(e2)
end
c22251201.named_with_Riviera=1
function c22251201.IsRiviera(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Riviera
end
function c22251201.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c22251201.announce_filter2={22250001,OPCODE_ISCODE,22250002,OPCODE_ISCODE,22250003,OPCODE_ISCODE,22250004,OPCODE_ISCODE,22250005,OPCODE_ISCODE,22250006,OPCODE_ISCODE,22250101,OPCODE_ISCODE,22250102,OPCODE_ISCODE,22250161,OPCODE_ISCODE,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR,OPCODE_OR}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c22251201.announce_filter2)) 
	c:SetHint(CHINT_CARD,ac)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c22251201.tgcon)
	e1:SetTarget(c22251201.tgtg)
	e1:SetOperation(c22251201.tgop)
	e1:SetLabel(ac)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
end
function c22251201.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c22251201.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22251201.filter,1,nil,e:GetLabel()) and rp==tp
end
function c22251201.tgfilter(c,code)
	return c22251201.IsRiviera(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c22251201.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22251201.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,0,0,0)
end
function c22251201.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22251201.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c22251201.costfilter(c)
	return c22251201.IsRiviera(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,c,c:GetCode())
end
function c22251201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22251201.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c22251201.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:Merge(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(Card.IsCode,nil,g:GetFirst():GetCode()):Select(tp,1,1,g:GetFirst()))
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c22251201.spfilter(c,e,tp)
	return c22251201.IsRiviera(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c22251201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22251201.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c22251201.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22251201.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function c22251201.tdcfilter(c)
	return c22251201.IsRiviera(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsPreviousLocation(LOCATION_GRAVE)
end
function c22251201.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22251201.tdcfilter,1,nil)
end
function c22251201.cfilter(c)
	return c:IsCode(22251201) and c:IsAbleToDeckAsCost()
end
function c22251201.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22251201.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c22251201.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c22251201.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22251201.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end


