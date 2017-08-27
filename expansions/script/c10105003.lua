--秋语 金盏菊·别离
function c10105003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10105003)
	e1:SetCondition(c10105003.spcon)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105003,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10105003.thcon)
	e2:SetTarget(c10105003.thtg)
	e2:SetOperation(c10105003.thop)
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(10105003,ACTIVITY_SUMMON,c10105003.counterfilter) 
end
function c10105003.thfilter(c)
	return c:IsSetCard(0xc330) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c10105003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105003.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10105003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10105003.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10105003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and (r==REASON_FUSION or e:GetHandler():IsReason(REASON_FUSION))
end
function c10105003.counterfilter(c)
	return not (c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND))
end
function c10105003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(10105003,tp,ACTIVITY_SUMMON)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
