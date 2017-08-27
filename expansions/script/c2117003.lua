--众合阎魔-乌莉丝
function c2117003.initial_effect(c)
	--instant
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2117003,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c2117003.cost2)
	e3:SetTarget(c2117003.sumtg)
	e3:SetOperation(c2117003.sumop)
	c:RegisterEffect(e3)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2117003,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,2117003)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c2117003.cost)
	e1:SetTarget(c2117003.shtg)
	e1:SetOperation(c2117003.shop)
	c:RegisterEffect(e1)
end
function c2117003.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c2117003.filter(c)
	return c:IsSetCard(0x21c) and not c:IsCode(2117003) and c:IsSummonable(true,nil)
end
function c2117003.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2117003.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c2117003.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c2117003.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c2117003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c2117003.filter(c)
	return c:IsSetCard(0x21c) and not c:IsCode(2117003) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2117003.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2117003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2117003.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c2117003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end