--紫电轰雷
function c50000062.initial_effect(c)
	c:EnableCounterPermit(0x150c,LOCATION_SZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c50000062.ctcon)
	e2:SetOperation(c50000062.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c50000062.efilter)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetDescription(aux.Stringid(50000062,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c50000062.thcon)
	e5:SetCost(c50000062.thcost)
	e5:SetTarget(c50000062.thtg)
	e5:SetOperation(c50000062.thop)
	c:RegisterEffect(e5)
end
function c50000062.thcon(e)
	local ct=e:GetHandler():GetCounter(0x150c)
	e:SetLabel(ct)
	return ct>0
end
function c50000062.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50000062.thfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c50000062.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000062.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50000062.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50000062.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--
function c50000062.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50000062.ctfilter,1,nil,tp)
end
function c50000062.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x150c,1)
end
function c50000062.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x50c) and c:IsControler(tp)
end
function c50000062.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsSetCard(0x50c)
end