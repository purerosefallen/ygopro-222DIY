--梅雨的黄伞-芒种
function c60605.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60605,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60605.condition)
	e1:SetCost(c60605.cost)
	e1:SetTarget(c60605.target)
	e1:SetOperation(c60605.operation)
	c:RegisterEffect(e1)
	--视频summon
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(60605,1))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60605+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c60605.drcost)
	e2:SetTarget(c60605.drtg)
	e2:SetOperation(c60605.drop)
	c:RegisterEffect(e2)
end
c60605.DescSetName = 0x229
function c60605.umbfilter(c,e,tp)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:GetAttack()==400 and c:GetDefense()==1000 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetCode())
end
function c60605.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c60605.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60605.cfilter,1,nil,1-tp)
end
function c60605.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60605.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),1-tp,0)
end
function c60605.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c60605.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c60605.filter,nil,e,1-tp)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c60605.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c60605.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c60605.umbfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c60605.drop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c60605.umbfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	while g:GetCount()>0 and ft>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummonStep(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	end
	Duel.SpecialSummonComplete()
end
