--ＬＰＭ 骑拉帝纳·起源型态
function c80000448.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)  
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c80000448.aclimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c80000448.aclimset)
	c:RegisterEffect(e3)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c80000448.distg)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c80000448.target)
	c:RegisterEffect(e6)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000448,0))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,80000448+EFFECT_COUNT_CODE_DUEL)
	e7:SetCost(c80000448.spcost)
	e7:SetCondition(c80000448.tdcon)
	e7:SetTarget(c80000448.tdtg)
	e7:SetOperation(c80000448.tdop)
	c:RegisterEffect(e7)
	--wudi 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c80000448.efilter)
	c:RegisterEffect(e8)	  
end
function c80000448.distg(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and not c:IsCode(80000269)
end
function c80000448.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000448.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE) or c:GetFlagEffect(80000448)>0
end
function c80000448.aclimset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(80000448,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		tc=eg:GetNext()
	end
end
function c80000448.target(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c80000448.tdfilter(c)
	return (c:IsLocation(0x1e) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsAbleToDeck()
end
function c80000448.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c80000448.tdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c80000448.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80000448.tdfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
end
function c80000448.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(80000448)==0
end
function c80000448.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,g,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,g,g,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end