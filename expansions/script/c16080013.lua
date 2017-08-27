--意料之外的伏杀
function c16080013.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c16080013.discon)
	e3:SetTarget(c16080013.distg)
	e3:SetOperation(c16080013.disop)
	c:RegisterEffect(e3)
end
function c16080013.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
		and Duel.IsChainNegatable(ev) and tp~=ep
end
function c16080013.filter(c,e)
	return c:IsFaceup()
end
function c16080013.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16080013.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16080013.rmfilter(c)
	return c:IsType(TYPE_MONSTER) 
end
function c16080013.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16080013.rmfilter,tp,LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0,true) 
	Duel.NegateActivation(ev)
	Duel.Destroy(eg,REASON_EFFECT)
end