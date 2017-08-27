--ＬＰＭ 雷希拉姆
function c80000463.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c80000463.spcon)
	e2:SetOperation(c80000463.spop)
	c:RegisterEffect(e2)   
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetDescription(aux.Stringid(80000463,1))
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCost(c80000463.cost)
	e4:SetTarget(c80000463.destg2)
	e4:SetOperation(c80000463.desop2)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetDescription(aux.Stringid(80000463,2))
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCost(c80000463.cost)
	e5:SetTarget(c80000463.destg3)
	e5:SetOperation(c80000463.desop3)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80000463,3))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetTarget(c80000463.damtg)
	e6:SetOperation(c80000463.damop)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c80000463.efilter)
	c:RegisterEffect(e7)
end
function c80000463.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000463.spcfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_SYNCHRO)
end
function c80000463.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c80000463.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,5,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
end
function c80000463.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80000463.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,5,5,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c80000463.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c80000463.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000463.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c80000463.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c80000463.desop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c80000463.filter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	end
end
function c80000463.filter3(c)
	return c:IsFaceup() 
end
function c80000463.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000463.filter3,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c80000463.filter3,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c80000463.desop3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c80000463.filter3,tp,0,LOCATION_SZONE,nil)
	local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	end
end
function c80000463.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c80000463.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80000463.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c80000463.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c80000463.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	Duel.Damage(p,ct*500,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end