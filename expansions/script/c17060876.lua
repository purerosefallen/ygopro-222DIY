--搭档丘豪
function c17060876.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_LINK),2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060876,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c17060876.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c17060876.efilter)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060876,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c17060876.spcost)
	e4:SetCondition(c17060876.negcon)
	e4:SetTarget(c17060876.negtg)
	e4:SetOperation(c17060876.negop)
	c:RegisterEffect(e4)
	--multi attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17060876,3))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(c17060876.raval)
	c:RegisterEffect(e5)
end
c17060876.is_named_with_Mercenary_Arthur=1
c17060876.is_named_with_Regal_Arthur=1
c17060876.is_named_with_Million_Arthur=1
function c17060876.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060876.IsRegal_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Regal_Arthur
end
function c17060876.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060876.incon(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=2
end
function c17060876.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c17060876.cfilter(c,g)
	return c:IsType(TYPE_MONSTER) and g:IsContains(c)
end
function c17060876.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c17060876.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c17060876.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c17060876.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=3 and Duel.IsChainNegatable(ev)
end
function c17060876.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c17060876.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c17060876.raval(e,c)
	local oc=e:GetHandler():GetLinkedGroupCount()
	return math.max(0,oc-1)
end