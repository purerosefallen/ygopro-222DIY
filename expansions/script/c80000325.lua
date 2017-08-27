--传说中的口袋妖怪 洛奇亚
function c80000325.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x12d0),10,3)
	c:EnableReviveLimit()  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000325,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c80000325.target)
	e2:SetOperation(c80000325.operation)
	c:RegisterEffect(e2) 
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000325.splimit)
	c:RegisterEffect(e4)  
	--todeck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000325,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c80000325.cost)
	e5:SetTarget(c80000325.tdtg)
	e5:SetOperation(c80000325.tdop)
	c:RegisterEffect(e5)
end
function c80000325.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000325.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end
function c80000325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000325.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c80000325.filter(c)
	return c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c80000325.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000325.filter,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_HAND+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c80000325.filter,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c80000325.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000325.filter,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end