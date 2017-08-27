--★星の世界の住人　アイシャ
function c114000701.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000701.atkcon)
	e1:SetCost(c114000701.atkcost)
	e1:SetOperation(c114000701.atkop)
	c:RegisterEffect(e1)
end
function c114000701.rmfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c114000701.atkcon(e,tp,eg,ep,ev,re,r,rp)
	--remove rel. (Temp. unnecessary)
	--local g=Duel.GetMatchingGroup(c114000701.rmfilter,tp,LOCATION_REMOVED,0,nil)
	--if g:GetCount()<=0 then return false end
	--battle rel.
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ( d~=nil and a:GetControler()==tp and a:IsSetCard(0x221) and a:IsRelateToBattle() )
		or ( d~=nil and d:GetControler()==tp and d:IsFaceup() and d:IsSetCard(0x221) and d:IsRelateToBattle() )
end
function c114000701.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c114000701.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c114000701.rmfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()<=0 then return end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(g:GetCount()*400)
	if a:GetControler()==tp then		
		a:RegisterEffect(e1)
	else
		d:RegisterEffect(e1)
	end
end