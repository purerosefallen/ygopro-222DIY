--靜儀式 彩壇の神樂
function c1200033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200033,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,1200133+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c1200033.condition)
	e1:SetCost(c1200033.cost)
	e1:SetOperation(c1200033.operation)
	c:RegisterEffect(e1)
	--CopyEffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200033,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,1200033)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1200033.ttarget)
	e1:SetOperation(c1200033.toperation)
	c:RegisterEffect(e1)
end
function c1200033.cfilter(c)
	return c:IsSetCard(0xfba) and c:IsReleasable()
end
function c1200033.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c1200033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200033.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	local cg=Duel.SelectMatchingCard(tp,c1200033.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Release(cg,REASON_COST)
end
function c1200033.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if Duel.NegateEffect(ev) then
		local tc=eg:GetFirst()
		--forbidden
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTarget(c1200033.bantg)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e2:SetTarget(c1200033.bantg)
		e2:SetLabelObject(tc)
		Duel.RegisterEffect(e2,tp)
	end
end
function c1200033.bantg(e,c)
	return c==e:GetLabelObject()
end
function c1200033.tfilter(c)
	return c:IsFaceup()
end
function c1200033.tgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xfba)
end
function c1200033.ttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1200033.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200033.tfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1200033.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1200033.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c1200033.toperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local tc=Duel.GetFirstTarget()
	if not Duel.IsExistingMatchingCard(c1200033.tgfilter,tp,LOCATION_DECK,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200033.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g:GetFirst()
	if Duel.SendtoGrave(sc,REASON_EFFECT)>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local code=sc:GetOriginalCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		tc:RegisterEffect(e1)
		tc:CopyEffect(code,RESET_EVENT+0x1fe0000)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(sc:GetAttack())
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetValue(sc:GetDefense())
		tc:RegisterEffect(e1)
	end
end