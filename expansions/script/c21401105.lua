--骑之从者 牛若丸
function c21401105.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
    e1:SetCategory(CATEGORY_COUNTER)
	e1:SetCost(c21401105.addcost)
	e1:SetTarget(c21401105.addtg)
	e1:SetOperation(c21401105.addop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetValue(c21401105.imfilter)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c21401105.damcon)
	e3:SetCost(c21401105.damcost)
	e3:SetOperation(c21401105.damop)
	c:RegisterEffect(e3)
end
function c21401105.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf00)
end
function c21401105.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SendtoExtraP(e:GetHandler(),tp,REASON_COST)
end
function c21401105.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable(e)
	    and Duel.IsExistingMatchingCard(c21401105.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(c21401105.cfilter,tp,LOCATION_MZONE,0,nil)
end
function c21401105.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c21401105.cfilter,tp,LOCATION_MZONE,0,nil)
    local tc=sg:GetFirst()
	  while tc do
        tc:AddCounter(0xf0f,1)
	    tc=sg:GetNext()
	  end
end
function c21401105.imfilter(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c21401105.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackAnnouncedCount()==0
end
function c21401105.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():GetAttackAnnouncedCount()==0 and e:GetHandler():IsCanRemoveCounter(tp,0xf0f,3,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,3,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+3 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401105.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=c:GetAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end