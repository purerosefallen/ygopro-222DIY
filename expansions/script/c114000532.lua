--ある絵画の末路
function c114000532.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c114000532.condition)
	e1:SetTarget(c114000532.target)
	e1:SetOperation(c114000532.activate)
	c:RegisterEffect(e1)
end
function c114000532.cfilter(c)
	return not ( c:IsSetCard(0x221) or c:IsCode(114000231) ) and c:IsType(TYPE_MONSTER)
end
function c114000532.atkfilter(c)
	return c:IsFaceup()
end
function c114000532.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() 
		and Duel.GetMatchingGroupCount(c114000532.atkfilter,tp,0,LOCATION_MZONE,nil)==1
		and not Duel.IsExistingMatchingCard(c114000532.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c114000532.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsAbleToRemove() and tg:IsCanBeEffectTarget(e) and Duel.GetAttackTarget()==nil end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function c114000532.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end