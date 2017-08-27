--DRRR!! 幻影华尔兹
function c80003032.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c80003032.handcon)
	c:RegisterEffect(e1) 
	--Activate(summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCondition(c80003032.condition1)
	e2:SetTarget(c80003032.target1)
	e2:SetOperation(c80003032.activate1)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e3)  
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c80003032.tg)
	c:RegisterEffect(e2) 
end
function c80003032.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x2da)
end
function c80003032.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(c80003032.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80003032.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c80003032.activate1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
end
function c80003032.filter(c)
	return c:IsFaceup() and c:IsCode(80003024)
end
function c80003032.handcon(e)
	return Duel.IsExistingMatchingCard(c80003032.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80003032.tg(e,c)
	return c:IsSetCard(0x2da) and c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()
end