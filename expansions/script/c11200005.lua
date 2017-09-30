--正义的伙伴 美树沙耶加
function c11200005.initial_effect(c)
	 aux.AddXyzProcedure(c,nil,8,2,c11200005.ovfilter,aux.Stringid(11200005,0),2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200005,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetCondition(c11200005.atkcon)
	e1:SetCost(c11200005.cost)
	e1:SetTarget(c11200005.atktg)
	e1:SetOperation(c11200005.atkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200005,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(c11200005.cost)
	e2:SetTarget(c11200005.distg)
	e2:SetOperation(c11200005.disop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(11200005,3))
	e3:SetRange(LOCATION_GRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1,11200005)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c11200005.descon)
	e3:SetCost(c11200005.descost)
	e3:SetTarget(c11200005.destg)
	e3:SetOperation(c11200005.desop)
	c:RegisterEffect(e3)  
	local e4=Effect.CreateEffect(c)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c11200005.flcon)
	e4:SetOperation(c11200005.flop)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c11200005.descon2)
	c:RegisterEffect(e5)
end
function c11200005.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x134) and c:IsType(TYPE_FUSION)
end
function c11200005.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c11200005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11200005.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c11200005.atkop(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if tg:GetCount()<=0 then return end
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-2000)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=tg:GetNext()
		end
end
function c11200005.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c11200005.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200005.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c11200005.disfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c11200005.disop(e,tp,eg,ep,ev,re,r,rp)
	 local og=Duel.GetMatchingGroup(c11200005.disfilter,tp,0,LOCATION_MZONE,nil)
	  if og:GetCount()==0 then return end
		local mg,matk=og:GetMaxGroup(Card.GetAttack)
		Duel.NegateRelatedChain(mg:GetFirst(),RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		mg:GetFirst():RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		mg:GetFirst():RegisterEffect(e2)
end
function c11200005.descon(e,tp,eg,ep,ev,re,r,rp)
	return Dulel.GetFlagEffect(tp,11200005)>0 
end
function c11200005.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11200005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11200005.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c11200005.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x134) and c:IsType(TYPE_MONSTER)
end
function c11200005.flcon(e,tp,eg,ep,ev,re,r,rp)
   if  not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11200005.desfilter,1,nil) 
end
function c11200005.flop(e,tp,eg,ep,ev,re,r,rp)
   Duel.RegisterFlagEffect(tp,11200005,RESET_EVENT+0xfe0000+RESET_CHAIN,0,1) 
end
function c11200005.descon2(e,tp,eg,ep,ev,re,r,rp)
	if tp==Duel.GetTurnPlayer() then return false end
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsFaceup() and tc:IsSetCard(0x134)
end