--剑之从者 盖乌斯·尤里乌斯·凯撒
function c21401102.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c21401102.dbcost)
	e1:SetTarget(c21401102.dbtg)
	e1:SetOperation(c21401102.dbop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+0xf0f)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c21401102.damcon)
	e2:SetOperation(c21401102.damop)
	c:RegisterEffect(e2)
    --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c21401102.descost2)
	e3:SetTarget(c21401102.destg2)
	e3:SetOperation(c21401102.desop2)
	c:RegisterEffect(e3)
end
function c21401102.dbfilter(c)
	return c:IsFaceup()
end
function c21401102.dbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SendtoExtraP(e:GetHandler(),tp,REASON_COST)
end
function c21401102.dbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21401102.dbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401102.dbfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401102,0))
	Duel.SelectTarget(tp,c21401102.dbfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21401102.dbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		tc:RegisterFlagEffect(21401102,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(21401102,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BATTLE_DAMAGE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c21401102.descon1)
		e1:SetTarget(c21401102.destg1)
		e1:SetOperation(c21401102.desop1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21401102.descon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(21401102)~=0
end
function c21401102.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21401102.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401102.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c21401102.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21401102.desop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401102,2))
	local g=Duel.SelectMatchingCard(tp,c21401102.filter,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21401102.filter2(c)
	return c:IsFaceup()
end
function c21401102.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,3,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,3,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+3 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401102.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401102.filter2,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c21401102.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21401102.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401102,3))
	local g=Duel.SelectMatchingCard(tp,c21401102.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21401102.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0xf00)
end
function c21401102.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT)
end