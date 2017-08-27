--太初龙剑士
function c10160009.initial_effect(c)
	--choose effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10160009,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10160009)
	e1:SetCost(c10160009.cost)
	e1:SetTarget(c10160009.tg)
	e1:SetOperation(c10160009.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
end
function c10160009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10160009.spfilter(c,e,tp)
	return c:IsCode(10160012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10160009.acfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsCode(10161001) and c:GetActivateEffect():IsActivatable(tp)
end
function c10160009.ssfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10160009.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c10160009.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	local b2=(Duel.IsExistingMatchingCard(c10160009.acfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(c10160009.ssfilter,tp,0,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
	local b3=(Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil))
	if chk==0 then return b1 or b2 or b3 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(10160009,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10160009,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(10160009,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	  e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	elseif sel==2 then
	  e:SetCategory(0)
	else
	  e:SetCategory(CATEGORY_DESTROY)
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
	end
end
function c10160009.op(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c10160009.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	local b2=(Duel.IsExistingMatchingCard(c10160009.acfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(c10160009.ssfilter,tp,0,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
	local b3=(Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil))
	 if sel==1 and b1 and c:IsRelateToEffect(e) and c:IsFaceup() and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c10160009.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	   if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		--g:GetFirst():RegisterEffect(e1)
	   end
	 elseif sel==2 and b2 then
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10160009,4))
	   local tc1=Duel.SelectMatchingCard(tp,c10160009.acfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	   local tc2=Duel.SelectMatchingCard(tp,c10160009.ssfilter,tp,0,LOCATION_GRAVE,1,1,nil):GetFirst()
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc1:GetActivateEffect()
		local tep=tc1:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc1,EVENT_CHAIN_SOLVED,tc1:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		Duel.SSet(tp,tc2,1-tp)
		Duel.ConfirmCards(1-tp,tc2)
	elseif sel==3 and b3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g1=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local g2=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
		g1:Merge(g2)
		Duel.Destroy(g1,REASON_EFFECT)
	end
end