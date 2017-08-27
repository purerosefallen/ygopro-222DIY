--四季的白泽球
function c22220161.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c22220161.Linkfilter),2)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220161,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(c22220161.condition)
	e2:SetTarget(c22220161.target)
	e2:SetOperation(c22220161.operation)
	c:RegisterEffect(e2)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c22220161.descon)
	e4:SetTarget(c22220161.destg)
	e4:SetOperation(c22220161.desop)
	c:RegisterEffect(e4)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220161,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCost(c22220161.cost)
	e2:SetTarget(c22220161.sptg)
	e2:SetOperation(c22220161.spop)
	c:RegisterEffect(e2)
end
c22220161.named_with_Shirasawa_Tama=1
function c22220161.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220161.Linkfilter(c)
	return c:IsFaceup() and c22220161.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER)
end
function c22220161.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22220161.filter(c,e)
	return c:IsDestructable() and c:IsAbleToRemove() and e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsType(TYPE_MONSTER)
end
function c22220161.rmfilter(c)
	return c22220161.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER)
end
function c22220161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22220161.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c22220161.climit)
end
function c22220161.climit(e,tp)
	return e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c22220161.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22220161.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and g:IsExists(c22220161.rmfilter,1,nil) then
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil) 
			if sg then
				Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
			end
		end
	end
end
function c22220161.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and (bc:IsLevelAbove(2) or bc:IsRankAbove(2))
end
function c22220161.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c22220161.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c22220161.cfilter(c)
	return c22220161.IsShirasawaTama(c) and c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c22220161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220161.cfilter,tp,LOCATION_REMOVED,0,4,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c22220161.cfilter,tp,LOCATION_REMOVED,0,4,4,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c22220161.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22220161.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end