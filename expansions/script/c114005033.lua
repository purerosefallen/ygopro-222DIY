--★聖女アイドルユニット カッシュマッシュ
function c114005033.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x4)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,114005033)
	e1:SetCondition(c114005033.condition)
	e1:SetTarget(c114005033.target)
	e1:SetOperation(c114005033.operation)
	c:RegisterEffect(e1)
	--negate
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1,114005034)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c114005033.discon)
	e2:SetOperation(c114005033.disop)
	c:RegisterEffect(e2)
end
--spsummon
function c114005033.otofilter(c)
	return c:IsSetCard(0xab0) or c:IsCode(21175632) or c:IsCode(68018709)
end
function c114005033.filter(c)
	return ( c:IsFaceup() and c114005033.otofilter(c) ) or c:IsFacedown() --not 0x199
end
function c114005033.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 ) and Duel.IsExistingMatchingCard(c114005033.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c114005033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114005033.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
--negate
function c114005033.selff(c,e)
	return c==e:GetHandler()
end
function c114005033.filter2(c,tp)
	return c114005033.filter(c) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) --not 0x199
end
function c114005033.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	--cannot activate if itself in battle and the target is itself
	local ph=Duel.GetCurrentPhase()	
	if (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and tg:IsExists(c114005033.selff,1,nil,e) then return false end
	--other limits
	return tg and tg:GetCount()==1 and tg:IsExists(c114005033.filter2,1,nil,tp) and Duel.IsChainDisablable(ev) and rp~=tp
end
function c114005033.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
end