--ex-大世界
function c80007022.initial_effect(c)
	c:SetUniqueOnField(1,0,80007022)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c80007022.adtg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c80007022.val)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c80007022.atktarget)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c80007022.descon)
	e4:SetTarget(c80007022.destg)
	e4:SetOperation(c80007022.desop)
	c:RegisterEffect(e4)
end
function c80007022.atktarget(e,c)
	return not c:IsSetCard(0x2d9)
end
function c80007022.adtg(e,c)
	return c:IsSetCard(0x2d9)
end
function c80007022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d9)
end
function c80007022.val(e,c)
	return Duel.GetMatchingGroupCount(c80007022.filter,c:GetControler(),LOCATION_MZONE,0,nil)*1000
end
function c80007022.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c80007022.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80007022.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(tp,ct*1000,REASON_EFFECT)
	end
end