--N.二阶堂 真红
function c80030003.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80030003.efilter)
	c:RegisterEffect(e1)   
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80030003.splimcon)
	e2:SetTarget(c80030003.splimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80030003,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,80030003)
	e5:SetCost(c80030003.cost)
	e5:SetTarget(c80030003.target)
	e5:SetOperation(c80030003.operation)
	c:RegisterEffect(e5)
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80030003,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,80030004)
	e6:SetCondition(c80030003.spcon)
	e6:SetTarget(c80030003.target1)
	e6:SetOperation(c80030003.operation1)
	c:RegisterEffect(e6)
end
function c80030003.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80030003.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80030003.splimit(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80030003.filter(c)
	return c:IsLevelBelow(2) and c:IsSetCard(0x92d4) and c:IsAbleToHand()
end
function c80030003.filter10(c)
	return c:IsLevelBelow(1) and c:IsAbleToHand()
end
function c80030003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c80030003.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(1-tp,c80030003.filter10,tp,0,LOCATION_DECK,1,1,nil)
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	if tc1 then Duel.ConfirmCards(1-tp,tc1) end
	if tc2 then Duel.ConfirmCards(tp,tc2) end
end
function c80030003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(1-tp,1000) and Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(1-tp,1000)
	Duel.PayLPCost(tp,1000)
end
function c80030003.filter1(c)
	return c:IsSetCard(0x92d4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevelBelow(9)
end
function c80030003.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80030003.filter1,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c80030003.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80030003.filter1,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80030003.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x92d4) and c:IsControler(tp)
end
function c80030003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c80030003.cfilter,1,nil,tp)
end