--传说的查阅
function c80090034.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80090034,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,80090034)
	e1:SetCondition(c80090034.condition)
	e1:SetCost(c80090034.cost)
	e1:SetOperation(c80090034.indop)
	c:RegisterEffect(e1)	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80090034,2))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1,80090035)
	e2:SetCondition(c80090034.condition1)
	e2:SetCost(c80090034.cost)
	e2:SetOperation(c80090034.indop1)
	c:RegisterEffect(e2)	
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80090034,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCountLimit(1,80090099)
	e3:SetCost(c80090034.discost)
	e3:SetOperation(c80090034.indop2)
	c:RegisterEffect(e3)   
	Duel.AddCustomActivityCounter(80090034,ACTIVITY_SPSUMMON,c80090034.counterfilter)
end
function c80090034.counterfilter(c)
	return c:IsSetCard(0x52d4)
end
function c80090034.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c80090034.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c80090034.cfilter,1,nil,1-tp)
end
function c80090034.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c80090034.cfilter,1,nil,tp)
end
function c80090034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80090034,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80090034.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c80090034.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x52d4)
end
function c80090034.tfilter(c)
	return c:IsCode(80090034) and c:IsAbleToHand()
end
function c80090034.indop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x52d4))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	local th=Duel.GetFirstMatchingCard(c80090034.tfilter,tp,LOCATION_DECK,0,nil)
	if th and Duel.SelectYesNo(tp,aux.Stringid(80090034,0)) then
	   Duel.SendtoHand(th,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,th)
	end
end
function c80090034.indop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x52d4))
	e1:SetValue(c80090034.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local th=Duel.GetFirstMatchingCard(c80090034.tfilter,tp,LOCATION_DECK,0,nil)
	if th and Duel.SelectYesNo(tp,aux.Stringid(80090034,0)) then
	   Duel.SendtoHand(th,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,th)
	end
end
function c80090034.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c80090034.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c80090034.indop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c80090034.con)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80090034.con(e)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end