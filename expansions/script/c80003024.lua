--DRRR!! 岸谷新罗
function c80003024.initial_effect(c)
	c:SetUniqueOnField(1,0,80003024) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c80003024.spcon)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,80003024)
	e2:SetTarget(c80003024.target)
	e2:SetOperation(c80003024.activate)
	c:RegisterEffect(e2)
	--cannot be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(c80003024.splimit)
	c:RegisterEffect(e4) 
	local e8=e4:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
end
function c80003024.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2da)
end
function c80003024.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c80003024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,1,nil)
	local rm=g1:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,rm,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,nil)
	local ds=g2:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ds,1,0,0)
end
function c80003024.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local rm=g1:GetFirst()
	if not rm:IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(rm,nil,2,REASON_EFFECT)==0 then return end
	local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ds=g2:GetFirst()
	if not ds:IsRelateToEffect(e) then return end
	Duel.Destroy(ds,REASON_EFFECT)
end



