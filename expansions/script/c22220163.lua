--乐园最高白泽球
function c22220163.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c22220163.Linkfilter),2)
	c:EnableReviveLimit()
	--IMMUNE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(c22220163.efilter)
	e1:SetTarget(c22220163.tgtg)
	c:RegisterEffect(e1)
	--CANNOT_DISEFFECT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c22220163.effectfilter)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_DICE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22220163.negcon)
	e1:SetTarget(c22220163.negtg)
	e1:SetOperation(c22220163.negop)
	c:RegisterEffect(e1)


end
c22220163.named_with_Shirasawa_Tama=1
function c22220163.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220163.Linkfilter(c)
	return c:IsFaceup() and c22220163.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER)
end
function c22220163.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c22220163.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c22220163.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return e:GetHandler():GetLinkedGroup():IsContains(tc)
end
function c22220163.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c22220163.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c22220163.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local i=tc:GetLevel()
	local j=tc:GetRank()
	local k1,k2=Duel.TossDice(tp,2)
	local k=k1+k2
	if i or j then
		if i>k or j>k then
			Duel.NegateActivation(ev)
			if re:GetHandler():IsRelateToEffect(re) then
				Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
