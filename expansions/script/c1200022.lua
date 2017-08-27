--LA SY 大安的卡蓮特兒
function c1200022.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1200022,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,1200022)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c1200022.atktg)
	e2:SetOperation(c1200022.atkop)
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c1200022.efilter)
	c:RegisterEffect(e2)
	--synlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c1200022.synlimit)
	c:RegisterEffect(e0)
	--CopyEffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200022,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c1200022.tcost)
	e1:SetTarget(c1200022.ttarget)
	e1:SetOperation(c1200022.toperation)
	c:RegisterEffect(e1)

end
function c1200022.efilter(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c1200022.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xfba)
end
function c1200022.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER)
end
function c1200022.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200022.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,0)
end
function c1200022.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if not Duel.IsExistingMatchingCard(c1200022.tgfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200022.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then 
		local atk=tc:GetAttack()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
			Duel.BreakEffect()
			local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			local sc=sg:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				sc=sg:GetNext()
			end
		end
	end
end
function c1200022.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c1200022.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfba)
end
function c1200022.tgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xfba)
end
function c1200022.ttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1200022.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1200022.tfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1200022.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1200022.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c1200022.toperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not Duel.IsExistingMatchingCard(c1200022.tgfilter,tp,LOCATION_DECK,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c1200022.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g:GetFirst()
	if Duel.SendtoGrave(sc,REASON_EFFECT)>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local code=sc:GetOriginalCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		tc:RegisterEffect(e1)
		tc:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end