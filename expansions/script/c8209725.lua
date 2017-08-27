--元素爆破波
function c8209725.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,8209725+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c8209725.cost)
	e1:SetTarget(c8209725.target)
	e1:SetOperation(c8209725.activate)
	c:RegisterEffect(e1)
end
function c8209725.cfilter(c)
	return  c:IsSetCard(0x1212) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_XYZ)  and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c8209725.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8209725.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c8209725.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c8209725.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function c8209725.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return false end
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetReleaseGroup(tp)
			local dg=Duel.GetMatchingGroup(c8209725.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
			local res=rg:IsExists(c8209725.costfilter,1,e:GetHandler(),e,dg)
			return res
		else
			return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetReleaseGroup(tp)
		local dg=Duel.GetMatchingGroup(c8209725.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c8209725.costfilter,1,1,e:GetHandler(),e,dg)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c8209725.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
		local dg=Duel.GetOperatedGroup()
		local dc=dg:GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and dc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(8209725,1)) then
			Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end