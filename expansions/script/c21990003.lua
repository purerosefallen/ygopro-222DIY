--秘术 遗忘之祭仪
function c21990003.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,21990003)
	e2:SetCondition(c21990003.spcon)
	e2:SetOperation(c21990003.spop)
	c:RegisterEffect(e2)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c21990003.efilter)
	c:RegisterEffect(e6)
	--copy trap
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21990003,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0x3c0)
	e5:SetCountLimit(1)
	e5:SetCondition(c21990003.condition)
	e5:SetCost(c21990003.cost)
	e5:SetTarget(c21990003.target)
	e5:SetOperation(c21990003.operation)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(21990003,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1)
	e6:SetCondition(c21990003.condition1)
	e6:SetCost(c21990003.cost)
	e6:SetTarget(c21990003.target2)
	e6:SetOperation(c21990003.operation)
	c:RegisterEffect(e6)
	if not c21990003.global_check then
		c21990003.global_check=true
		c21990003[0]=0
		c21990003[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c21990003.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c21990003.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c21990003.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c21990003.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsType(TYPE_QUICKPLAY) then
			c21990003[tc:GetControler()]=c21990003[tc:GetControler()]+1
		end
		tc=eg:GetNext()
	end
end
function c21990003.clear(e,tp,eg,ep,ev,re,r,rp)
	c21990003[0]=0
	c21990003[1]=0
end
function c21990003.spfilter(c,tp)
	return not c:IsPublic() and c:IsSetCard(0x9219) and Duel.IsExistingMatchingCard(c21990003.filter,tp,LOCATION_HAND,0,1,c)
end
function c21990003.filter(c)
	return c:IsSetCard(0xa219) and not c:IsPublic() 
end
function c21990003.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and Duel.IsExistingMatchingCard(c21990003.spfilter,c:GetControler(),LOCATION_HAND,0,1,e:GetHandler(),c:GetControler())
end
function c21990003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c21990003.spfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c21990003.filter,tp,LOCATION_HAND,0,1,1,nil)
	g1:Merge(g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
end
function c21990003.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.CheckEvent(EVENT_CHAINING) and c21990003[e:GetHandler():GetControler()]>=2
end
function c21990003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return e:GetHandler():GetFlagEffect(21990003)==0 end
	e:GetHandler():RegisterFlagEffect(21990003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c21990003.filter1(c)
	return c:IsType(TYPE_QUICKPLAY) and not c:IsSetCard(0x9219) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c21990003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c21990003.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21990003.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c21990003.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c21990003.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsType(TYPE_QUICKPLAY) and not c:IsSetCard(0x9219) and c:IsAbleToGraveAsCost() then
		if c:CheckActivateEffect(false,true,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if not te then return false end
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end
function c21990003.condition1(e,tp,eg,ep,ev,re,r,rp)
	return c21990003[e:GetHandler():GetControler()]>=2
end
function c21990003.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c21990003.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21990003.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c21990003.filter1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end