--冰海的银屑 亚鲁
function c2100007.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c2100007.spcon)
	c:RegisterEffect(e2)
	--tuner
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,2100007)
	e2:SetCondition(c2100007.condition)
	e2:SetCost(c2100007.cost)
	e2:SetTarget(c2100007.tg)
	e2:SetOperation(c2100007.op)
	c:RegisterEffect(e2)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2100007,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c2100007.tdtg)
	e1:SetOperation(c2100007.tdop)
	c:RegisterEffect(e1)
end
function c2100007.filter(c)
	return c:IsSetCard(0x3219) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c2100007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0 and
		Duel.IsExistingMatchingCard(c2100007.filter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,5,nil)
end
function c2100007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3219)
end
function c2100007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2100007.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2100007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c2100007.cfilter1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToHand()
end
function c2100007.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c2100007.cfilter1(chkc) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c2100007.cfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c2100007.cfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c2100007.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c2100007.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c2100007.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c2100007.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c2100007.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c2100007.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c2100007.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end