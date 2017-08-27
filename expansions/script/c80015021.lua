--反叛的战神 吉尔
function c80015021.initial_effect(c)
	c:EnableReviveLimit()
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c80015021.imcon)
	e2:SetValue(c80015021.efilter)
	c:RegisterEffect(e2)
	--cannot disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c80015021.effcon)
	c:RegisterEffect(e3)  
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c80015021.atkval)
	c:RegisterEffect(e4) 
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80015021,2))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1e0)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c80015021.negcost2)
	e5:SetTarget(c80015021.target1)
	e5:SetOperation(c80015021.operation1)
	c:RegisterEffect(e5)
	--material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c80015021.discost)
	e6:SetCondition(c80015021.imcon1)
	e6:SetTarget(c80015021.target)
	e6:SetOperation(c80015021.operation)
	c:RegisterEffect(e6)
	--attack all
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_ATTACK_ALL)
	e7:SetValue(1)
	e7:SetCondition(c80015021.imcon2)
	c:RegisterEffect(e7)
end
function c80015021.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c80015021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c80015021.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c80015021.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
	Duel.SelectMatchingCard(tp,c80015021.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
end
function c80015021.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c80015021.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=g:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.HintSelection(og)
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c80015021.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80015021.imcon(e)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=5
end
function c80015021.imcon1(e)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=3
end
function c80015021.imcon2(e)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=4
end
function c80015021.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x32d7)
end
function c80015021.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c80015021.atkval(e,c)
	return c:GetOverlayCount()*400
end
function c80015021.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() 
end
function c80015021.negcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c80015021.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80015021.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80015021.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
end
function c80015021.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end