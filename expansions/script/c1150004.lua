--点心时间
function c1150004.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150004+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1150004.cost1)
	e1:SetTarget(c1150004.tg1)
	e1:SetOperation(c1150004.op1)
	c:RegisterEffect(e1)   
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(2,1150005)
	e2:SetCost(c1150004.cost2)
	e2:SetOperation(c1150004.op2)
	c:RegisterEffect(e2)
end
--
function c1150004.cfilter1(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL)
end
function c1150004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150004.cfilter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1150004.cfilter1,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())  
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--
function c1150004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--
function c1150004.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetTargetRange(1,0)
	e1_1:SetValue(c1150004.val1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(e:GetHandler())
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_CHAINING)
	e1_2:SetProperty(EFFECT_FLAG_DELAY)
	e1_2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1_2:SetOperation(c1150004.op1_2)
	Duel.RegisterEffect(e1_2,tp)
	Duel.BreakEffect()
	if Duel.Recover(tp,500,REASON_EFFECT)~=0 then
		e:GetHandler():CancelToGrave()
		if Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)~=0 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
--
function c1150004.val1_1(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
--
function c1150004.ofilter1_2(c,tp)
	return c:GetControler()~=tp
end
function c1150004.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c1150004.ofilter1_2,nil,tp)
	if g:GetCount()~=0 then
		Duel.Recover(tp,100,REASON_EFFECT)
	end
end
--
function c1150004.cfilter2(c)
	return c:IsCode(1150004) and c:IsAbleToRemoveAsCost()
end
function c1150004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1150004.cfilter2,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>=3 end
	local rg=g:Select(tp,3,3,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
--
function c1150004.op2(e,tp,eg,ep,ev,re,r,rp)
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_CHANGE_DAMAGE)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetTargetRange(1,0)
	e2_1:SetValue(0)
	e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2_1,tp)
	Duel.BreakEffect()
	Duel.Recover(tp,2000,REASON_EFFECT)
end

