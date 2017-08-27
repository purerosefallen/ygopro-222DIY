--夜雀之白泽球
function c22220008.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_MSET)
	e2:SetCountLimit(1,22220008)
	e2:SetRange(LOCATION_REMOVED+LOCATION_HAND)
	e2:SetCondition(c22220008.scon)
	e2:SetTarget(c22220008.sptg)
	e2:SetOperation(c22220008.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetTarget(c22220008.postg)
	e3:SetCondition(c22220008.poscon)
	e3:SetOperation(c22220008.posop)
	c:RegisterEffect(e3)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220008,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22220008)
	e1:SetTarget(c22220008.target)
	e1:SetOperation(c22220008.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c22220008.named_with_Shirasawa_Tama=1
function c22220008.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22220008.scon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c22220008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22220008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function c22220008.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL 
end
function c22220008.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not (c:IsType(TYPE_SPELL) and c:IsType(TYPE_PENDULUM))
end
function c22220008.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220008.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c22220008.posop(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetMatchingGroupCount(c22220008.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if m<1 then return false end
	if m>1 then m=2 end
	local tg=Duel.SelectMatchingCard(tp,c22220008.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,m,nil)
	local mtg=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local stg=tg:Filter(Card.IsLocation,nil,LOCATION_SZONE)
	if mtg:GetCount()>0 then 
		Duel.ChangePosition(mtg,POS_FACEDOWN_DEFENSE)
	end
	if stg:GetCount()>0 then 
		Duel.ChangePosition(stg,POS_FACEDOWN)
		Duel.RaiseEvent(stg,EVENT_SSET,e,REASON_EFFECT,tp,1-tp,0) 
	end
end
function c22220008.filter(c,e,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and (not e or c:IsRelateToEffect(e))
end
function c22220008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22220008.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c22220008.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c22220008.filter,nil,e,tp)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end