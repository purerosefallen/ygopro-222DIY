--口袋妖怪电蜘蛛的领域
function c80000354.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT+RACE_THUNDER))
	e5:SetValue(300)
	c:RegisterEffect(e5) 
	--defup
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6) 
	--trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c80000354.check)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(80000354,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+80000354)
	e3:SetCountLimit(1,80000354)
	e3:SetTarget(c80000354.target)
	e3:SetOperation(c80000354.operation)
	c:RegisterEffect(e3) 
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(80000354,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c80000354.thcon)
	e4:SetTarget(c80000354.thtg)
	e4:SetOperation(c80000354.thop)
	c:RegisterEffect(e4) 
end
function c80000354.val(e,c)
	local r=c:GetRace()
	if bit.band(r,RACE_INSECT+RACE_THUNDER)>0 then return 300
	else return 0 end
end
function c80000354.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsReason(REASON_RELEASE+REASON_COST)
			and (tc:IsRace(RACE_INSECT) or tc:IsRace(RACE_THUNDER)) and tc:GetLevel()~=0 and tc:IsPreviousPosition(POS_FACEUP) then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+80000354,e,r,rp,tc:GetControler(),tc:GetLevel())
		end
		tc=eg:GetNext()
	end
end
function c80000354.filter(c,lv)
	return c:IsRace(RACE_INSECT+RACE_THUNDER) and c:GetLevel()==lv and c:IsAbleToHand() and c:IsSetCard(0x2d0)
end
function c80000354.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c80000354.filter,tp,LOCATION_DECK,0,1,nil,ev) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c80000354.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000354.filter,tp,LOCATION_DECK,0,1,1,nil,ev)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80000354.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()==5 and c:IsPreviousPosition(POS_FACEUP)
end
function c80000354.thfilter(c)
	return c:IsSetCard(0x2d0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsRace(RACE_INSECT+RACE_THUNDER) and c:IsLevelBelow(4)
end
function c80000354.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80000354.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000354.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c80000354.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c80000354.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end