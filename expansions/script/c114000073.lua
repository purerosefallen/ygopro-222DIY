--★魔法少女マジカルハート
function c114000073.initial_effect(c)
	--spsummon on monster destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c114000073.condition)
	e1:SetTarget(c114000073.target)
	e1:SetOperation(c114000073.operation)
	c:RegisterEffect(e1)
	--spsummon on direct attack
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c114000073.dircon)
	c:RegisterEffect(e2)
end
--on monster destoryed condition
function c114000073.cfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_BATTLE)
	    and c:GetPreviousControler()==tp
end
function c114000073.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c114000073.cfilter,1,nil,tp)
end
function c114000073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000073.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--on direct attack condition
function c114000073.dircon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end