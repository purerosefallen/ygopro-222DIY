--新津 月华宫
function c16080011.initial_effect(c)
	c:SetUniqueOnField(1,0,16080011)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c16080011.target)
	e2:SetOperation(c16080011.activate)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16080011,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c16080011.dmtg)
	e3:SetOperation(c16080011.dmop)
	c:RegisterEffect(e3)
end
function c16080011.filter(c,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c16080011.pcfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c16080011.pcfilter(c,lv)
	return c:IsSetCard(0x5ca) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:GetLevel()==lv and c:IsAbleToHand()
end
function c16080011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c16080011.filter,tp,LOCATION_MZONE,0,1,nil,tp) 
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c16080011.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c16080011.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c16080011.pcfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c16080011.tdfilter(c)
	return c:IsSetCard(0x5ca) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c16080011.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16080011.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,2,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c16080011.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16080011.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	if g:GetCount()~=2 then return end
		Duel.SendtoHand(g,nil,2,REASON_EFFECT)
end