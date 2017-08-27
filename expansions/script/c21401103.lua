--Archer 罗宾汉
function c21401103.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(c21401103.atkcost)
	e1:SetTarget(c21401103.atktg)
	e1:SetOperation(c21401103.atkop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EVENT_ADD_COUNTER+0xf0f)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c21401103.acop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c21401103.descost)
	e3:SetTarget(c21401103.destg)
	e3:SetOperation(c21401103.desop)
	c:RegisterEffect(e3)
end
function c21401103.cfilter(c)
	return c:GetAttack()~=0 and c:IsFaceup()
end
function c21401103.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SendtoExtraP(e:GetHandler(),tp,REASON_COST)
end
function c21401103.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard( c21401103.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
end
function c21401103.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	  local tc=g:GetFirst()
	  while tc do
		 local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_UPDATE_ATTACK)
		 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		 e1:SetValue(-300)
		 e1:SetReset(RESET_EVENT+0x1fe0000)
		 tc:RegisterEffect(e1)
		 tc=g:GetNext()
	  end
end
function c21401103.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf0f,1)
end
function c21401103.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,3,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,3,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+3 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401103.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c21401103.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c21401103.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21401103.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21401103,0))
	local g=Duel.SelectTarget(tp,c21401103.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetAttack()
	local batk=tc:GetBaseAttack()
	if atk<batk then
		Duel.SetOperationInfo(0,CATEGORY_REMOVED,tc,1,0,0)
    else
	    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	end
end
function c21401103.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local batk=tc:GetBaseAttack()
		if atk<batk then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		else
		Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end