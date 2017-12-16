--剧本制作
function c22261001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22261001,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22261001.con)
	e1:SetCost(c22261001.cost)
	e1:SetTarget(c22261001.target1)
	e1:SetOperation(c22261001.activate1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22261001,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22261001.con)
	e2:SetCost(c22261001.cost)
	e2:SetTarget(c22261001.target2)
	e2:SetOperation(c22261001.activate2)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22261001,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c22261001.cost)
	e3:SetTarget(c22261001.tg)
	e3:SetOperation(c22261001.op)
	c:RegisterEffect(e3)
end
function c22261001.IsKuMaKawa(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KuMaKawa
end
function c22261001.cfilter(c)
	return c:IsFacedown() or c:GetBaseAttack()~=0
end
function c22261001.con(e,c)
	return not Duel.IsExistingMatchingCard(c22261001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22261001.cfilterx(c)
	return c:IsCode(22269999) and c:IsReleasable()
end
function c22261001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22261001.cfilterx,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c22261001.cfilterx,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22261001.rmfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and not c:IsType(TYPE_TOKEN)
end
function c22261001.kfilter(c)
	return c:IsFaceup() and c22261001.IsKuMaKawa(c)
end
function c22261001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()-Duel.GetMatchingGroupCount(c22261001.kfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,30459350) and ct>0 and g:IsExists(c22261001.rmfilter,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c22261001.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(1-tp,30459350) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()-Duel.GetMatchingGroupCount(c22261001.kfilter,tp,LOCATION_MZONE,0,nil)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(1-tp,c22261001.rmfilter,ct,ct,nil,1-tp)
		Duel.Remove(sg,POS_FACEUP,REASON_RULE)
	end
end
function c22261001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c22261001.atkfilter(c)
	return c:IsFaceup() and c22261001.IsKuMaKawa(c)
end
function c22261001.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local ag=Duel.GetMatchingGroup(c22261001.atkfilter,tp,LOCATION_MZONE,0,nil)
	local sum=ag:GetSum(Card.GetAttack)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(sum)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c22261001.cfilter(c)
	return c:IsCode(22269999) and c:IsReleasable()
end
function c22261001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22261001.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c22261001.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22261001.filter(c)
	return c:IsCode(22261101) and c:IsAbleToHand()
end
function c22261001.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22261001.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c22261001.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22261001.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end