--春 淚  雨 泣 小 恋
local m=46564024
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)	
	--control
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_CONTROL)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,m)
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.cttg)
	e6:SetOperation(cm.ctop)
	c:RegisterEffect(e6)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsCode(m)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0 and
		Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGraveAsCost()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
