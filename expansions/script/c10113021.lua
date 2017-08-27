--伊卡洛斯之短剑
function c10113021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10113021+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c10113021.eqtg)
	e1:SetOperation(c10113021.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10113021.effcon)
	c:RegisterEffect(e2)  
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c10113021.atkval)
	--c:RegisterEffect(e3)  
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10113021.descon)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c10113021.imcon)
	e5:SetValue(c10113021.efilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(c10113021.imcon)
	e6:SetValue(c10113021.efilter)
	c:RegisterEffect(e6)
end
function c10113021.imcon(e)
	return not c10113021.descon(e)
end
function c10113021.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10113021.descon(e)
	return Duel.IsExistingMatchingCard(c10113021.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler(),e:GetHandler())
end
function c10113021.desfilter(c,rc)
	return rc:GetEquipTarget() and c~=rc:GetEquipTarget()
end
function c10113021.effcon(e,c)
	return c:GetControler()==e:GetHandlerPlayer()
end
function c10113021.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10113021.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c10113021.atkval(e,c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()*100
	else return c:GetLevel()*100
	end
end