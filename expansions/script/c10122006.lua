--空想的低语
function c10122006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,10122006)
	e1:SetTarget(c10122006.target)
	e1:SetOperation(c10122006.activate)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10122006,4))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)   
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10122106)
	e2:SetCost(c10122006.cost)
	e2:SetTarget(c10122006.settg)
	e2:SetOperation(c10122006.setop)
	c:RegisterEffect(e2)  
end
function c10122006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10122006)==0 end
	e:GetHandler():RegisterFlagEffect(10122006,RESET_CHAIN,0,1)
end
function c10122006.desfilter(c)
	return c:GetSequence()==5 and c:IsDestructable() and c:IsFaceup() and c:IsSetCard(0xc333)
end
function c10122006.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c10122006.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10122006.desfilter,tp,LOCATION_SZONE,0,1,nil) and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10122006.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c10122006.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsSSetable() then
	   Duel.BreakEffect()
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c10122006.atkfilter(c)
	return c:IsFaceup() and c:IsCode(10122011)
end
function c10122006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10122006.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10122006.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10122006.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,800)
end
function c10122006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		if Duel.GetTurnPlayer()==tp then
		  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
		  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		e1:SetValue(3000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetDescription(aux.Stringid(10122006,2))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetOwnerPlayer(tp)
		if Duel.GetTurnPlayer()==tp then
		  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
		  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		e2:SetValue(c10122006.efilter)
		tc:RegisterEffect(e2)
	end
end
function c10122006.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end