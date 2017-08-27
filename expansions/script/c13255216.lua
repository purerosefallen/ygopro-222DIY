--纳克鲁斯
function c13255216.initial_effect(c)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c13255216.con)
	e1:SetCost(c13255216.cost)
	e1:SetOperation(c13255216.op)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c13255216.drcon)
	e2:SetOperation(c13255216.drop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c13255216.target)
	e3:SetOperation(c13255216.activate)
	c:RegisterEffect(e3)
	
end
function c13255216.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(13255216)==0 and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function c13255216.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(13255216,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c13255216.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(13255216,0)) then
		local c=e:GetHandler()
		local ct=Duel.DiscardHand(tp,aux.TRUE,1,2,REASON_EFFECT+REASON_DISCARD)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(ct*1500)
		c:RegisterEffect(e1)
	end
end
function c13255216.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c13255216.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(13255216,1)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c13255216.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13255216.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13255216.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c13255216.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(13255216,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c13255216.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
