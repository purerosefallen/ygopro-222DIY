--霏雪的黄伞-立冬
function c61107.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61107,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c61107.condition)
	e1:SetCost(c61107.cost)
	e1:SetTarget(c61107.target)
	e1:SetOperation(c61107.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(61107,2))
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	--search
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(61107,1))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,61107+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c61107.drcost)
	e2:SetTarget(c61107.drtg)
	e2:SetOperation(c61107.drop)
	c:RegisterEffect(e2)
end
c61107.DescSetName = 0x229
function c61107.umbfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0x229 and c:IsAbleToHand()
end
function c61107.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_DECK)
end
function c61107.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c61107.cfilter,1,nil,1-tp)
end
function c61107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c61107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c61107.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c61107.cfilter,nil,1-tp)
	if sg:GetCount()>0 then
		local g=eg:Select(tp,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c61107.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c61107.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61107.umbfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c61107.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c61107.umbfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
