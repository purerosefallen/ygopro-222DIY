--精灵剑舞守护
function c5200018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5200018+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c5200018.cost)
	e1:SetTarget(c5200018.target)
	e1:SetOperation(c5200018.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x360))
	e2:SetValue(c5200018.indval)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(5200018,ACTIVITY_SPSUMMON,c5200018.counterfilter)
end
function c5200018.filter(c)
	return c:IsSetCard(0x360) and c:IsAbleToHand() and not c:IsCode(5200018) and c:IsType(TYPE_SPELL)
end  
function c5200018.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x360) 
end
function c5200018.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
function c5200018.counterfilter(c)
	return c:IsSetCard(0x360) or c:GetSummonLocation()~=LOCATION_EXTRA
end
function c5200018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(5200018,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c5200018.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c5200018.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x360) and c:IsLocation(LOCATION_EXTRA)
end
function c5200018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5200018.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5200018.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5200018.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end