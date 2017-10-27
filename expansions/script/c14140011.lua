--nyanyanya
function c14140011.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14140011,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,14140011)
	e1:SetCost(c14140011.rmcost)
	e1:SetTarget(c14140011.rmtg)
	e1:SetOperation(c14140011.rmop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(0x14000)
	e4:SetCondition(c14140011.descon2)
	e4:SetTarget(c14140011.sptg)
	e4:SetOperation(c14140011.spop)
	c:RegisterEffect(e4)
end
function c14140011.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(14140011,0x1fe1000+RESET_CHAIN,0,1)
end
function c14140011.rmfilter(c,e,tp)
	return c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function c14140011.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14140011.rmfilter,tp,0,LOCATION_EXTRA,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c14140011.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c14140011.rmfilter,tp,0,LOCATION_EXTRA,nil,e,tp)
	if g:GetCount()==0 then return end
	local tc=g:RandomSelect(tp,1):GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		if e:GetHandler():GetFlagEffect(14140011)>0 then
			e:GetHandler():SetCardTarget(tc)		
		end
		Duel.SpecialSummonComplete()
	end
end
function c14140011.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c14140011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14140011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end