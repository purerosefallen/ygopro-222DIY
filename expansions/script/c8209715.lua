--轻装上阵的架空者
function c8209715.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8209715+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8209715.cost)
	e1:SetTarget(c8209715.target)
	e1:SetOperation(c8209715.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(8209715,ACTIVITY_SPSUMMON,c8209715.counterfilter)
end
function c8209715.counterfilter(c)
	return c:IsSetCard(0x1212)
end
function c8209715.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(8209715,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c8209715.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c8209715.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x1212)
end
function c8209715.filter(c,e,tp)
	return c:IsSetCard(0x1212) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8209715.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8209715.filter,tp,LOCATION_DECK,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c8209715.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c8209715.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=2 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(8209715,RESET_EVENT+0x1fe0000,0,1,fid)
			tc=sg:GetNext()
		end
		sg:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c8209715.descon)
		e3:SetOperation(c8209715.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c8209715.desfilter(c,fid)
	return c:GetFlagEffectLabel(8209715)==fid
end
function c8209715.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c8209715.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c8209715.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c8209715.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
