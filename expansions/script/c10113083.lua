--超维宇宙
function c10113083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_SPSUMMON)
	e1:SetTarget(c10113083.target1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113083,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c10113083.target)
	e2:SetOperation(c10113083.operation)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c10113083.descon)
	c:RegisterEffect(e3)
end
function c10113083.descon(e)
	return not Duel.IsExistingMatchingCard(c10113083.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) and Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c10113083.desfilter(c)
	return c:IsFaceup() and c:IsCode(10113074,10113075)
end
function c10113083.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res and c10113083.target(e,tp,teg,tep,tev,tre,tr,trp,0) and Duel.SelectYesNo(tp,aux.Stringid(10113083,1)) then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetOperation(c10113083.operation)
		c10113083.target(e,tp,teg,tep,tev,tre,tr,trp,1)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10113083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10113083.cfilter,1,nil) end
	local g=eg:Filter(c10113083.cfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_MZONE)
end
function c10113083.cfilter(c)
	return c:IsFaceup() and not c:IsCode(10113074,10113075) and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsAbleToRemove() and c:IsLocation(LOCATION_MZONE)
end
function c10113083.cfilter2(c,e)
	return c10113083.cfilter(c) and c:IsRelateToEffect(e)
end
function c10113083.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c10113083.cfilter2,nil,e)
	if g:GetCount()<=0 or Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local og=Duel.GetOperatedGroup()
	local oc=og:GetFirst()
	local tc=g:GetFirst()
		while oc do
			oc:RegisterFlagEffect(10113083,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(c10113083.retop)
		Duel.RegisterEffect(e1,tp)
end
function c10113083.retfilter(c)
	return c:GetFlagEffect(10113083)~=0
end
function c10113083.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c10113083.retfilter,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end