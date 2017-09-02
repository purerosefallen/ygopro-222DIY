--Darkest　沉寂的古镇
function c22231202.initial_effect(c)
	c:SetUniqueOnField(1,0,22231202)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pos
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_POSITION+CATEGORY_DRAW)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c22231202.postg)
	e6:SetOperation(c22231202.posop)
	c:RegisterEffect(e6)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c22231202.reptg)
	e2:SetValue(c22231202.repval)
	e2:SetOperation(c22231202.repop)
	c:RegisterEffect(e2)
end
c22231202.named_with_Darkest_D=1
function c22231202.IsDarkest(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkest_D
end
function c22231202.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22231202.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) then
			if c22231202.IsDarkest(tc) then 
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
function c22231202.repfilter(c,tp)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c22231202.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and eg:IsExists(c22231202.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(22231202,0))
end
function c22231202.repval(e,c)
	return c22231202.repfilter(c,e:GetHandlerPlayer())
end
function c22231202.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end