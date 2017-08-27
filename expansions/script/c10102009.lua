--神圣之舞
function c10102009.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c10102009.cost)
	e1:SetTarget(c10102009.target)
	e1:SetOperation(c10102009.activate)
	c:RegisterEffect(e1)
end
function c10102009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10102009.cfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9330)
end
function c10102009.spfilter(c,e,tp,type,sumtype)
	return c:IsType(type) and c:IsSetCard(0x9330) and c:IsCanBeSpecialSummoned(e,sumtype,tp,false,false)
end
function c10102009.cfilter2(c,e,tp)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9330) and c10102009.cfilter3(e,tp,c)
end
function c10102009.cfilter3(e,tp)
	return Duel.IsExistingMatchingCard(c10102009.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,TYPE_MONSTER,0) and Duel.IsExistingMatchingCard(c10102009.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,TYPE_MONSTER,0)
end
function c10102009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b0=Duel.IsExistingMatchingCard(c10102009.cfilter,tp,LOCATION_GRAVE,0,5,nil)
	local b1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
	local b3=c10102009.cfilter3(e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	local b4=Duel.IsExistingMatchingCard(c10102009.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,TYPE_SYNCHRO,SUMMON_TYPE_SYNCHRO) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then 
		if e:GetLabel()==1 then
		   e:SetLabel(0)
		   return b0 and (b1 or b2 or b3 or b4)
		else
		   return b1 or b2 or b3 or b4
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local tg=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if b3 and not b1 and not b2 and not b4 then
		   tg=Duel.SelectMatchingCard(tp,c10102009.cfilter2,tp,LOCATION_GRAVE,0,5,5,nil,e,tp)
		else
		   tg=Duel.SelectMatchingCard(tp,c10102009.cfilter,tp,LOCATION_GRAVE,0,5,5,nil,e,tp)
		end
		if tg and tg:GetCount()>0 then
		   Duel.SendtoDeck(tg,nil,2,REASON_COST)
		end
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(10102009,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10102009,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(10102009,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(10102009,3)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DESTROY)
		local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_DESTROY)
		local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	elseif sel==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
	end
end
function c10102009.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel,dg=e:GetLabel()
	if sel==1 then
		dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	elseif sel==2 then
		dg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.Destroy(dg,REASON_EFFECT)
	elseif sel==3 then
		if not c10102009.cfilter3(e,tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=Duel.SelectMatchingCard(tp,c10102009.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,TYPE_MONSTER,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(tp,c10102009.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,TYPE_MONSTER,0)
		if not sg2:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		   sg1:Merge(sg2)
		end
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c10102009.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,TYPE_SYNCHRO,SUMMON_TYPE_SYNCHRO)
		if sg:GetCount()>0 and Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
		   sg:GetFirst():CompleteProcedure()
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end