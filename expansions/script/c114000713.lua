--いしのなかにいる
function c114000713.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c114000713.condition)
	e1:SetTarget(c114000713.target)
	e1:SetOperation(c114000713.activate)
	c:RegisterEffect(e1)
end
function c114000713.cfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and ( c:IsSetCard(0x221) or c:IsCode(114000231) )
end
function c114000713.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c114000713.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c114000713.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c114000713.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114000713.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c114000713.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c114000713.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c114000713.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		--cannot activate
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,1)
		e1:SetValue(c114000713.aclimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c114000713.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return (loc==LOCATION_REMOVED) and re:IsActiveType(TYPE_MONSTER)
end