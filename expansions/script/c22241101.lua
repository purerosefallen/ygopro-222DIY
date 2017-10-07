--Solid 零二七
function c22241101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,222411011+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22241101.cost)
	e1:SetTarget(c22241101.target)
	e1:SetOperation(c22241101.operation)
	c:RegisterEffect(e1)
	--Release-
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22241101,0))
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,222411012)
	e2:SetCondition(c22241101.adcon)
	e2:SetTarget(c22241101.adtg)
	e2:SetOperation(c22241101.adop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
c22241101.named_with_Solid=1
function c22241101.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22241101.cfilter(c)
	return c:IsReleasableByEffect() and c22241101.IsSolid(c)
end
function c22241101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22241101.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c22241101.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c22241101.filter1(c)
	return c:IsReleasableByEffect() and c:IsFaceup()
end
function c22241101.filter2(c)
	return c:IsReleasableByEffect() and c:IsFacedown()
end
function c22241101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsReleasableByEffect() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c22241101.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) and Duel.IsExistingTarget(c22241101.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c22241101.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c22241101.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g1,g1:GetCount(),0,0)
end
function c22241101.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Release(g,REASON_EFFECT)
end
function c22241101.adcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return bit.band(e:GetHandler():GetReason(),REASON_RELEASE)~=0
end
function c22241101.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,LOCATION_SZONE)
end
function c22241101.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Release(tc,REASON_EFFECT)
	end
end