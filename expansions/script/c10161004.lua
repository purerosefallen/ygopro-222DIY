--太古的守护
function c10161004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10161004,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetCost(c10161004.cost)
	e2:SetTarget(c10161004.tg)
	e2:SetOperation(c10161004.activate)
	c:RegisterEffect(e2) 
	--avoid damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10161004,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c10161004.avcon)
	e3:SetOperation(c10161004.avop)
	c:RegisterEffect(e3) 
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c10161004.damop)
	c:RegisterEffect(e4)  
end
c10161004.card_code_list={10160001}
function c10161004.damfilter(c,sp)
	return c:GetSummonPlayer()==sp and c:IsSetCard(0x9333)
end
function c10161004.damop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c10161004.damfilter,1,nil,tp) then 
	 Duel.Hint(HINT_CARD,0,10161004)
	 Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
function c10161004.avop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c10161004.avcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_DECK) and c:IsPreviousPosition(POS_FACEUP)
end
function c10161004.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return tp~=Duel.GetTurnPlayer() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c10161004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10161004.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ac=Duel.GetAttacker()
	if Duel.NegateAttack() and ac:IsRelateToBattle() and ac:IsFaceup() then
	   Duel.ChangePosition(ac,POS_FACEDOWN_DEFENSE)
	end
end
