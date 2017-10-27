--新津 阿卡纳
function c16080005.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16080005)
	e1:SetTarget(c16080005.target)
	e1:SetOperation(c16080005.operation)
	c:RegisterEffect(e1)
	--lvchange
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c16080005.lvtg)
	e2:SetOperation(c16080005.lvop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(c16080005.thcon)
	e3:SetTarget(c16080005.thtg)
	e3:SetOperation(c16080005.thop)
	c:RegisterEffect(e3)
end
function c16080005.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5ca) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function c16080005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) and 
	Duel.IsExistingMatchingCard(c16080005.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c16080005.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g1,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16080005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
		c:CompleteProcedure()
	end
end
function c16080005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5ca) and c:GetLevel()~=2
end
function c16080005.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16080005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16080005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16080005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c16080005.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c16080005.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CONTINUOUS_POS) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsPreviousPosition(POS_FACEUP_DEFENSE)
end
function c16080005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c16080005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end