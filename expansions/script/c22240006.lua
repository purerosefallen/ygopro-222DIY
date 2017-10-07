--Solid 零九五五
function c22240006.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22240006,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,222400061)
	e3:SetCondition(c22240006.scon)
	e3:SetTarget(c22240006.stg)
	e3:SetOperation(c22240006.sop)
	c:RegisterEffect(e3)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,222400062)
	e1:SetCondition(c22240006.hspcon)
	e1:SetOperation(c22240006.hspop)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e1)
	--Change position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22240006,1))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,222400063)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCost(c22240006.cost)
	e3:SetCondition(c22240006.condition)
	e3:SetTarget(c22240006.target)
	e3:SetOperation(c22240006.operation)
	c:RegisterEffect(e3)
end
c22240006.named_with_Solid=1
function c22240006.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22240006.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_SZONE)
end
function c22240006.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22240006.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c22240006.spfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsFaceup() and c:IsCanTurnSet()
end
function c22240006.hspcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c22240006.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c22240006.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c22240006.spfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c22240006.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c22240006.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return np~=pp and c:IsReleasableByEffect()
end
function c22240006.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22240006.cfilter,1,nil) and eg:GetCount()==1
end
function c22240006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,tc) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,0,1,0,0)
end
function c22240006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.Release(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,1,1,nil)
		if g then Duel.Release(g,REASON_EFFECT) end
	end
end