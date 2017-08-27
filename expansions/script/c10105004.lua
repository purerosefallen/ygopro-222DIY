--秋语 薰衣草·守候
function c10105004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10105004)
	e1:SetCondition(c10105004.spcon)
	c:RegisterEffect(e1)	
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105004,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10105004.thcon)
	e2:SetTarget(c10105004.thtg)
	e2:SetOperation(c10105004.thop)
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(10105004,ACTIVITY_CHAIN,c10105004.counterfilter) 
end
function c10105004.thfilter(c)
	return c:IsSetCard(0xc330) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10105004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105004.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10105004.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c10105004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and (r==REASON_FUSION or e:GetHandler():IsReason(REASON_FUSION))
end
function c10105004.counterfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_SPELLCASTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WIND) and re:IsActiveType(TYPE_MONSTER))
end
function c10105004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(10105004,tp,ACTIVITY_CHAIN)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end