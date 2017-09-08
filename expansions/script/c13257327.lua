--超时空武装 副炮-穿甲导弹
function c13257327.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(c13257327.eqlimit)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(c13257327.econ)
	e12:SetValue(c13257327.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257327,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c13257327.destg)
	e3:SetOperation(c13257327.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257327,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c13257327.damcon)
	e4:SetTarget(c13257327.damtg)
	e4:SetOperation(c13257327.damop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetCondition(c13257327.damcon1)
	c:RegisterEffect(e5)
	
end
function c13257327.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x6352)
end
function c13257327.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function c13257327.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c13257327.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c13257327.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13257327.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c13257327.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13257327.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13257327.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c13257327.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c13257327.cfilter1(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE)
end
function c13257327.damcon(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c13257327.cfilter,1,nil,1-tp) then return false end
	local rc=re:GetHandler()
	local c=e:GetHandler()
	return c:GetEquipTarget() and (rc==c or rc==c:GetEquipTarget())
end
function c13257327.damcon1(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c13257327.cfilter1,1,nil,1-tp) then return false end
	local rc=eg:GetFirst():GetReasonCard()
	local c=e:GetHandler()
	return c:GetEquipTarget() and (rc==c or rc==c:GetEquipTarget())
end
function c13257327.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c13257327.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
