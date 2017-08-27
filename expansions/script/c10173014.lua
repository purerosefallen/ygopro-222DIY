--溢彩流光
function c10173014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10173014+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c10173014.cost)
	e1:SetTarget(c10173014.tg)
	e1:SetOperation(c10173014.op)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173014,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10173014.rcon)
	e2:SetOperation(c10173014.rop)
	c:RegisterEffect(e2)	
end
function c10173014.rcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and re:GetHandlerPlayer()==tp and c:IsRace(RACE_BEAST) and c:GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToRemove()
end
function c10173014.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	if ct==1 then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
end
function c10173014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10173014.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c10173014.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil,e,tp,c:GetRank())
end
function c10173014.spfilter(c,e,tp,rk)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_BEAST) and c:GetLevel()==rk
end
function c10173014.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10173014.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10173014.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetRank())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10173014.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10173014.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,e:GetLabel())
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if sg:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then return end
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
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
	tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c10173014.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end