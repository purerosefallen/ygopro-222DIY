--幻层驱动 导流层
function c10130007.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c10130007.flipop)
	c:RegisterEffect(e1)	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c10130007.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetValue(c10130007.repval)
	e3:SetCondition(c10130007.indcon)
	e3:SetTarget(c10130007.reptg)
	e3:SetOperation(c10130007.repop)
	c:RegisterEffect(e3)
	--extra set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_EXTRA_SET_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10130007.indcon)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c10130007.target)
	e5:SetValue(c10130007.indct)
	c:RegisterEffect(e5)
	--flip
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_FLIP)
	ge1:SetOperation(c10130007.checkop)
	Duel.RegisterEffect(ge1,0)
end
function c10130007.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsSetCard,nil,0xa336)
	if tg:GetCount()<=0 then return end
	local tc=tg:GetFirst()
	while tc do
	  tc:RegisterFlagEffect(10130007,RESET_EVENT+0x1fe0000,0,0)
	tc=tg:GetNext()
	end
end
function c10130007.target(e,c)
	return c:IsSetCard(0xa336) and c:GetFlagEffect(10130007)>0
end
function c10130007.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c10130007.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFacedown() and not c:IsHasEffect(EFFECT_CANNOT_CHANGE_POSITION)
end
function c10130007.repval(e,c)
	return c10130007.repfilter(c,e:GetHandlerPlayer())
end
function c10130007.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10130007)
	local tg=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,tg)
	Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
end
function c10130007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c10130007.repfilter,1,nil,tp) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_CHANGE_POSITION) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	local tg=eg:Filter(c10130007.repfilter,nil,tp)
	tg:KeepAlive()
	e:SetLabelObject(tg)
	return Duel.SelectYesNo(tp,aux.Stringid(10130007,0))
end
function c10130007.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10130007,RESET_EVENT+0x1fe0000,0,1)
end
function c10130007.indcon(e)
	return e:GetHandler():GetFlagEffect(10130007)~=0
end