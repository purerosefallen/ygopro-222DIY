--口袋妖怪 Mega耿鬼
function c80000071.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)  
	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)   
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c80000071.con)
	c:RegisterEffect(e4)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1)
	e2:SetTarget(c80000071.target)
	e2:SetOperation(c80000071.activate)
	c:RegisterEffect(e2)
end
function c80000071.con(e)
	return not Duel.IsExistingMatchingCard(Card.IsAttackPos,e:GetHandler():GetControler(),0,LOCATION_MZONE,1,nil)
end
function c80000071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
	local rm=g1:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rm,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	local ds=g2:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,ds,1,0,0)
end
function c80000071.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local rm=g1:GetFirst()
	if not rm:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(rm,nil,2,REASON_EFFECT)==0 then return end
	local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local ds=g2:GetFirst()
	if not ds:IsRelateToEffect(e) then return end
	Duel.Remove(ds,POS_FACEDOWN,REASON_EFFECT)
end