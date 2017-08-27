--N.九十九 有码
function c80030011.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80030011.efilter)
	c:RegisterEffect(e1)   
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80030011.splimcon)
	e2:SetTarget(c80030011.splimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	--tribute limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TRIBUTE_LIMIT)
	e5:SetValue(c80030011.tlimit)
	c:RegisterEffect(e5)
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e6)
	--multi attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EXTRA_ATTACK)
	e7:SetValue(8)
	c:RegisterEffect(e7)
	--atk clear
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_BATTLED)
	e8:SetOperation(c80030011.retop)
	c:RegisterEffect(e8)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(80030011,1))
	e9:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_BATTLE_DAMAGE)
	e9:SetCondition(c80030011.condition)
	e9:SetTarget(c80030011.target)
	e9:SetOperation(c80030011.operation)
	c:RegisterEffect(e9)
	--tograve
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(80030011,2))
	e10:SetCategory(CATEGORY_TOGRAVE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e10:SetCode(EVENT_TO_GRAVE)
	e10:SetCountLimit(1,80030011)
	e10:SetCondition(c80030011.descon)
	e10:SetTarget(c80030011.target1)
	e10:SetOperation(c80030011.operation1)
	c:RegisterEffect(e10)
	--summon with 3 tribute
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(80030011,0))
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e11:SetCondition(c80030011.ttcon)
	e11:SetOperation(c80030011.ttop)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e12)
end
function c80030011.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80030011.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80030011.splimit(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030011.tlimit(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030011.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c80030011.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c80030011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end
function c80030011.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2,d3=Duel.TossDice(tp,3)
	if d1+d2+d3==9 then
		Duel.Damage(1-tp,999,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(999)
		c:RegisterEffect(e1)
	end
end
function c80030011.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c==Duel.GetAttacker() then
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
end
function c80030011.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c80030011.filter(c)
	return c:IsSetCard(0x92d4) and c:IsAbleToGrave()
end
function c80030011.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80030011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c80030011.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80030011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c80030011.descon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x92d4)) or  bit.band(r,REASON_EFFECT)~=0
end