--Solid Space
function c22241501.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,22241501)
	e1:SetCost(c22241501.cost)
	e1:SetTarget(c22241501.target)
	e1:SetOperation(c22241501.operation)
	c:RegisterEffect(e1)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetCondition(c22241501.immcon)
	e4:SetTarget(c22241501.tgtg)
	e4:SetValue(c22241501.tgvalue)
	c:RegisterEffect(e4)

end
c22241501.named_with_Solid=1
function c22241501.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22241501.cfilter1(c)
	return c22241501.IsSolid(c) and c:IsReleasable()
end
function c22241501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22241501.cfilter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c22241501.cfilter1,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c22241501.filter1(c,e)
	return c~=e:GetLabelObject() and bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsAbleToHand()
end
function c22241501.filter2(c,e,tp)
	return bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsType(TYPE_SPELL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and not c:IsType(TYPE_PENDULUM)
end
function c22241501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMatchingGroupCount(c22241501.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)>0 or Duel.GetMatchingGroupCount(c22241501.filter2,tp,LOCATION_SZONE,0,nil,e,tp)>0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g1=Duel.GetMatchingGroup(c22241501.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local g2=Duel.GetMatchingGroup(c22241501.filter2,tp,LOCATION_SZONE,0,nil,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		op=Duel.SelectOption(tp,aux.Stringid(22241501,0),aux.Stringid(22241501,1))
	elseif g1:GetCount()>0 and (g2:GetCount()<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1) then
		op=Duel.SelectOption(tp,aux.Stringid(22241501,0))
	elseif g1:GetCount()<1 and g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		op=Duel.SelectOption(tp,aux.Stringid(22241501,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
	end
end
function c22241501.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local g=Duel.SelectMatchingCard(tp,c22241501.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local g=Duel.SelectMatchingCard(tp,c22241501.filter2,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		end
	end
end
function c22241501.tgtg(e,c)
	return c22241501.IsSolid(c) and c:IsFaceup()
end
function c22241501.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<2 and e:GetHandler():IsFaceup()
end
function c22241501.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end