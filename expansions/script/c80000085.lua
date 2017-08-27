--口袋妖怪 Mega妙蛙花
function c80000085.initial_effect(c)
	c:EnableCounterPermit(0x18)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000) 
	--spsummon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.FALSE)
	c:RegisterEffect(e7)   
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000085,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c80000085.cttg)
	e1:SetOperation(c80000085.ctop)
	c:RegisterEffect(e1)
	--atk def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_DAMAGE_CALCULATING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c80000085.adval)
	c:RegisterEffect(e2)
	--atk,pos limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetTarget(c80000085.target)
	c:RegisterEffect(e8)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c80000085.target)
	c:RegisterEffect(e4)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000085,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,80000085+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c80000085.atkcost)
	e3:SetOperation(c80000085.atkop)
	c:RegisterEffect(e3)
	--Add counter2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetOperation(c80000085.addop2)
	c:RegisterEffect(e6)
	--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetCondition(c80000085.descon2)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--battle indestructable
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e9:SetCondition(c80000085.descon2)
	e9:SetValue(1)
	c:RegisterEffect(e9) 
end
function c80000085.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x18)>1
end
function c80000085.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=eg:GetFirst()
	while c~=nil do
		if not c:IsCode(80000085) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) then
			count=count+c:GetCounter(0x18)
		end
		c=eg:GetNext()
	end
	if count>0 then
		e:GetHandler():AddCounter(0x18,count)
	end
end
function c80000085.damfilter(c)
	return c:GetCounter(0x18)>0
end
function c80000085.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,1,1,0x18)>0 end
	local g=Duel.GetMatchingGroup(c80000085.damfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		local sct=tc:GetCounter(0x18)
		tc:RemoveCounter(tp,0x18,sct,0)
		sum=sum+sct
		tc=g:GetNext()
	end
	e:SetLabel(sum)
end
function c80000085.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c80000085.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c80000085.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x18,1)
		tc=g:GetNext()
	end
end
function c80000085.addown(c,e)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
	e1:SetValue(c:GetCounter(0x18)*-1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c80000085.adval(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return end
	if a:GetCounter(0x18)>0 and d:IsCode(80000085) then c80000085.addown(a,e) end
	if d:GetCounter(0x18)>0 and a:IsCode(80000085) then c80000085.addown(d,e) end
end
function c80000085.target(e,c)
	return c~=e:GetHandler() and c:GetCounter(0x18)~=0
end
