--口袋妖怪 碧粉蝶 -雪原花纹-
function c80000350.initial_effect(c)
	c:EnableReviveLimit()
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000350,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,80000350)
	e2:SetCost(c80000350.thcost)
	e2:SetTarget(c80000350.thtg)
	e2:SetOperation(c80000350.thop)
	c:RegisterEffect(e2)   
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2d0))
	e3:SetValue(c80000350.atkval)
	c:RegisterEffect(e3) 
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c80000350.atkval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.FALSE)
	c:RegisterEffect(e6)  
end
function c80000350.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c80000350.thfilter(c)
	return c:IsSetCard(0x2d0) and c:IsRace(RACE_INSECT) and c:GetLevel()==6 and c:IsAbleToHand() and not c:IsCode(80000350)
end
function c80000350.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000350.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000350.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000350.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80000350.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c80000350.atkval(e,c)
	return Duel.GetMatchingGroupCount(c80000350.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
function c80000350.atkval1(e,c)
	return -(Duel.GetMatchingGroupCount(c80000350.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200)
end