--Caster 汉斯克·里斯蒂安·安徒生
function c21401113.initial_effect(c)
	c:EnableCounterPermit(0xf0f)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21401113,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c21401113.addcost)
    e1:SetTarget(c21401113.addtg)
	e1:SetOperation(c21401113.addop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21401113,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c21401113.atkcost)
	e2:SetCondition(c21401113.atkcon)
	e2:SetTarget(c21401113.atktg)
	e2:SetOperation(c21401113.atkop)
	c:RegisterEffect(e2)
end
function c21401113.cfilter(c)
	return c:IsSetCard(0xf0b) and not c:IsPublic()
end
function c21401113.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21401113.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c21401113.cfilter,tp,LOCATION_HAND,0,1,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetCount())
end
function c21401113.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0xf0f)
end
function c21401113.addop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xf0f,e:GetLabel())
	end
end
function c21401113.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xf0f,2,REASON_COST) end
	local c1=e:GetHandler():GetCounter(0xf0f)
	e:GetHandler():RemoveCounter(tp,0xf0f,2,REASON_COST)
	local c2=e:GetHandler():GetCounter(0xf0f)
	if c1==c2+2 then
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+0xf0f,e,0,tp,0,0)
	end
end
function c21401113.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c21401113.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and Duel.IsDamageCalculated() then return false end
	return true
end
function c21401113.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    recover=0
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
		    atk1=sc:GetAttack()
			def1=sc:GetDefense()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(800)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			atk2=sc:GetAttack()
			def2=sc:GetDefense()
			recover=recover+atk2+def2-atk1-def1
			sc=g:GetNext()
		end
		Duel.Recover(tp,recover/2,REASON_EFFECT)
	end
end