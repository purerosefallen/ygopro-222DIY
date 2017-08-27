--口袋妖怪 Mega喷火龙X
function c80000083.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000) 
	--spsummon condition
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(aux.FALSE)
	c:RegisterEffect(e7)  
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000083,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCountLimit(1,80000083)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c80000083.adcon)
	e5:SetTarget(c80000083.tg)
	e5:SetOperation(c80000083.op)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c80000083.atkval)
	c:RegisterEffect(e6)
	--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c80000083.accon)
	e2:SetValue(c80000083.efilter)
	c:RegisterEffect(e2) 
	--battle destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000083,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c80000083.condition)
	e1:SetTarget(c80000083.target)
	e1:SetOperation(c80000083.operation)
	c:RegisterEffect(e1)   
end
function c80000083.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c80000083.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end 
function c80000083.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)==Duel.GetLP(1-tp)-0
end
function c80000083.atkval(e,c)
	local lps=Duel.GetLP(c:GetControler())
	local lpo=Duel.GetLP(1-c:GetControler())
	if lps>=lpo then return 0
	else return lpo-lps end
end
function c80000083.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000083.accon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c80000083.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c80000083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
end
function c80000083.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end


