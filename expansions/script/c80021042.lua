--魔王的争斗
function c80021042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,80021042+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c80021042.condition)
	e1:SetTarget(c80021042.target)
	e1:SetOperation(c80021042.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80021042.handcon)
	c:RegisterEffect(e2)  
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c80021042.reptg)
	e3:SetValue(c80021042.repval)
	e3:SetOperation(c80021042.repop)
	c:RegisterEffect(e3)  
end
function c80021042.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x92d5)
end
function c80021042.handcon(e)
	return Duel.IsExistingMatchingCard(c80021042.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80021042.cfilter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_DARK)
end
function c80021042.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and not Duel.IsExistingMatchingCard(c80021042.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and rp~=tp
end
function c80021042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c80021042.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
end
function c80021042.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x92d5) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c80021042.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c80021042.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(80021042,0))
end
function c80021042.repval(e,c)
	return c80021042.repfilter(c,e:GetHandlerPlayer())
end
function c80021042.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end