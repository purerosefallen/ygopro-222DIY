--必殺！合体破り！
function c114000557.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(c114000557.cost)
	e1:SetTarget(c114000557.target)
	e1:SetOperation(c114000557.activate)
	c:RegisterEffect(e1)
end
--cost
function c114000557.costfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c114000557.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000557.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c114000557.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
--target
function c114000557.filter(c,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetSummonPlayer()~=tp
	and c:IsAbleToDeck()
	--and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c114000557.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:IsExists(c114000557.filter,1,nil,tp) end
	local g=eg:Filter(c114000557.filter,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
--activate
function c114000557.filter2(c,e,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA)
		and c:GetSummonPlayer()~=tp and c:IsAbleToDeck() and c:IsRelateToEffect(e)
		--and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c114000557.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c114000557.filter2,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local dct=0
	while tc do
		if tc:IsType(TYPE_EFFECT) and not tc:IsDisabled() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			dct=dct+Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) --count no. of monsters completed the step
			tc=g:GetNext()
		end
	end
	if dct>0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetTarget(c114000557.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c114000557.splimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA)
end