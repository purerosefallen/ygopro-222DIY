--七大魔王 暴走懒惰
function c80021022.initial_effect(c)
	c:SetUniqueOnField(1,1,80021022)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa2d5),7,3,c80021022.ovfilter,aux.Stringid(80021022,0),3,c80021022.xyzop)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)  
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80021022.efilter)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e3)
	--cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c80021022.ccost)
	c:RegisterEffect(e4)
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(80021022,1))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c80021022.atkcon)
	e8:SetTarget(c80021022.atktg)
	e8:SetOperation(c80021022.atkop)
	c:RegisterEffect(e8)
end
function c80021022.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c80021022.cfilter(c)
	return c:IsSetCard(0xa2d5) and c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c80021022.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80021010) and Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c80021022.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80021022.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c80021022.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c80021022.atkfilter(c,e,tp)
	return c:IsControler(tp) and (not e or c:IsRelateToEffect(e)) 
end
function c80021022.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())  
end
function c80021022.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c80021022.atkop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
		tc=eg:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c80021022.ccost(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80021022,0)) then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end