--Sawawa-Over the Life Hurtling
local m=37564215
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,2,true,false,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,m)
	e1:SetCondition(Senya.CheckNoExtra)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	if not tc:IsLocation(LOCATION_REMOVED) then return end
	local cp=tc:GetOwner()
	if Duel.GetLocationCount(cp,LOCATION_MZONE)==0 or not tc:IsType(TYPE_MONSTER) then
		Duel.SendtoGrave(tc,REASON_RULE)
		return
	end
	Duel.MoveToField(tc,cp,cp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
end