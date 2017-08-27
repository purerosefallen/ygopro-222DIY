--超时空武装 主炮-环形镭射
function c13257309.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257309.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257309.econ)
	e12:SetValue(c13257309.efilter)
	c:RegisterEffect(e12)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c13257309.tg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c13257309.tg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257309,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c13257309.destg)
	e3:SetOperation(c13257309.desop)
	c:RegisterEffect(e3)
	
end
function c13257309.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function c13257309.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257309.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257309.filter(c,def)
	return c:IsFaceup() and c:IsAttackBelow(def)
end
function c13257309.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return tc and Duel.IsExistingMatchingCard(c13257309.filter,tp,0,LOCATION_MZONE,1,tc,tc:GetDefense()) end
	local g=Duel.GetMatchingGroup(c13257309.filter,tp,0,LOCATION_MZONE,tc,tc:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c13257309.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c13257309.filter,tp,0,LOCATION_MZONE,tc,tc:GetDefense())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c13257309.tg(e,c)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	return c:IsSetCard(0x351) or tc==c
end
