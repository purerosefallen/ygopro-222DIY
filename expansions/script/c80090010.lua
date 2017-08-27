--情热传说 艾丽夏
function c80090010.initial_effect(c)
	c:SetUniqueOnField(1,0,80090010)	 
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c80090010.sumop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c80090010.reptg)
	e4:SetValue(c80090010.repval)
	e4:SetOperation(c80090010.repop)
	c:RegisterEffect(e4)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80090010,6))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_CONFIRM)
	e5:SetTarget(c80090010.targ)
	e5:SetOperation(c80090010.op)
	c:RegisterEffect(e5)
end
function c80090010.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,80090010)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x52d4))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,80090010,RESET_PHASE+PHASE_END,0,1)
end
function c80090010.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x52d4) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c80090010.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c80090010.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(80090010,0))
end
function c80090010.repval(e,c)
	return c80090010.repfilter(c,e:GetHandlerPlayer())
end
function c80090010.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c80090010.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() and t:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,t,1,0,0)
end
function c80090010.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() and not t:IsAttackPos() then
		Duel.SendtoDeck(t,nil,2,REASON_EFFECT)
		Duel.ChainAttack()
	end
end