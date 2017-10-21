--超时空武装 副炮-双向导弹
function c13257330.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257330.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257330.econ)
	e12:SetValue(c13257330.efilter)
	c:RegisterEffect(e12)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257330,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_EQUIP)
	e3:SetCountLimit(1)
	e3:SetCondition(c13257330.econ)
	e3:SetTarget(c13257330.destg)
	e3:SetOperation(c13257330.desop)
	c:RegisterEffect(e3)
	
end
function c13257330.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x6352)
end
function c13257330.econ(e)
	return e:GetHandler():GetEquipTarget() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c13257330.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257330.desfilter(c,ec)
	return not ec:GetColumnGroup():IsContains(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c13257330.leftfilter(c,seq)
	return c:GetSequence()>4-seq and c:GetSequence()<5
end
function c13257330.rightfilter(c,seq)
	return c:GetSequence()<4-seq or c:GetSequence()==5
end
function c13257330.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c13257330.desfilter,tp,0,LOCATION_ONFIELD,1,nil,ec) end
	local g=Duel.GetMatchingGroup(c13257330.desfilter,tp,0,LOCATION_ONFIELD,nil,ec)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13257330.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ec=e:GetHandler():GetEquipTarget()
	local g=Duel.GetMatchingGroup(c13257330.desfilter,tp,0,LOCATION_ONFIELD,nil,ec)
	if g:GetCount()>0 then
		local seq=ec:GetSequence()
		if seq==5 then seq=1
		elseif seq==6 then seq=3 end
		local sg=Group.CreateGroup()
		local g1=g:Filter(c13257330.leftfilter,nil,seq)
		local g2=g:Filter(c13257330.rightfilter,nil,seq)
		if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(13257330,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			sg:Merge(sg1)
			if sg1:GetFirst():IsLocation(LOCATION_FZONE) then
				g2:Sub(sg1)
			end
		end
		if g2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(13257330,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg2)
			sg:Merge(sg2)
		end
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
