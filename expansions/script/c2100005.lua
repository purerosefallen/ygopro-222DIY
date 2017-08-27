--落幕的银屑 流连
function c2100005.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2100005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,2100005)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c2100005.cost)
	e1:SetTarget(c2100005.target)
	e1:SetOperation(c2100005.operation)
	c:RegisterEffect(e1)
end
function c2100005.cfilter(c)
	return c:IsSetCard(0x3219) and c:IsLevelBelow(4) and c:IsAbleToGraveAsCost()
end
function c2100005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():GetFlagEffect(6511113)==0 end
	e:GetHandler():RegisterFlagEffect(6511113,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c2100005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c2100005.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c2100005.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tg=g:GetFirst()
	e:SetLabelObject(tg)
end
function c2100005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc then
		local code=tc:GetOriginalCode()
		local reset_flag=RESET_EVENT+0x1fe0000
		c:CopyEffect(code, reset_flag)
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	end
end