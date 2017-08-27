--222 审核
function c80010023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80010023+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c80010023.cost)
	e1:SetTarget(c80010023.target)
	e1:SetOperation(c80010023.activate)
	c:RegisterEffect(e1)	
end
function c80010023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c80010023.filter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c80010023.activate(e,tp,eg,ep,ev,re,r,rp)
	local t1=Duel.GetFirstMatchingCard(c80010023.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,80010025)
	if not t1 then return end
	local t2=Duel.GetFirstMatchingCard(c80010023.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,80010027)
	if not t2 then return end
	local g=Group.FromCards(t1,t2)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
function c80010023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.CheckLPCost(tp,1000) end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	Duel.PayLPCost(tp,1000)
end