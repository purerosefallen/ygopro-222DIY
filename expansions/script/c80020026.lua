--堕天堂 暗黑炽天使
function c80020026.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),99,99,c80020026.ovfilter,aux.Stringid(80020026,0),5)
	c:EnableReviveLimit()  
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--immune spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c80020026.efilter)
	c:RegisterEffect(e3)
	--cannot trigger
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0xa,0xa)
	e4:SetTarget(c80020026.distg)
	c:RegisterEffect(e4)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(c80020026.distg)
	c:RegisterEffect(e2)
	--multi attack
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80020026,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c80020026.cost)
	e6:SetCondition(c80020026.mtcon)
	e6:SetOperation(c80020026.mtop)
	c:RegisterEffect(e6)
end
function c80020026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80020026.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80020000) and Duel.GetLP(tp)<=1000
end
function c80020026.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c80020026.distg(e,c)
	return c:IsType(TYPE_SPELL)
end
function c80020026.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=7
end
function c80020026.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(1-tp,7)
	local g=Duel.GetDecktopGroup(1-tp,7)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_SPELL)
	Duel.ShuffleDeck(1-tp)
	if ct>1 then
		Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	elseif ct==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(6)
		c:RegisterEffect(e1)
	end
end