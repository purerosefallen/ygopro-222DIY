--圣谕守护者 扎克利
function c10102005.initial_effect(c)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10102005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10102005)
	e1:SetCondition(c10102005.spcon)
	e1:SetTarget(c10102005.sptg)
	e1:SetOperation(c10102005.spop)
	c:RegisterEffect(e1) 
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10102005,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,10102105)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10102005.efcost)
	e2:SetTarget(c10102005.eftg)
	e2:SetOperation(c10102005.efop)
	c:RegisterEffect(e2)
	c10102005[c]=e2 
end
function c10102005.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c10102005.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c[c]
	if not te or c:GetOriginalCode()<10102001 or c:GetOriginalCode()>10102099 or not c:IsAbleToRemoveAsCost() then return false end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c) then return false end
	return true
end
function c10102005.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsReleasable()
			and Duel.IsExistingMatchingCard(c10102005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c10102005.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local te=tc[tc]   
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
	   tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c10102005.efop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10102005.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp and c:IsSetCard(0x9330)
end
function c10102005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10102005.cfilter,1,nil,tp)
end
function c10102005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10102005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end