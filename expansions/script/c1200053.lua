--LA 最後的靜儀式
function c1200053.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c1200053.matfilter,2)
	c:EnableReviveLimit()
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200053,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c1200053.scon)
	e3:SetTarget(c1200053.stg)
	e3:SetOperation(c1200053.sop)
	c:RegisterEffect(e3)
	--SetLP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200053,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c1200053.tpcost)
	e3:SetOperation(c1200053.tpop)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200053,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1200053.spcost)
	e3:SetTarget(c1200053.sptg)
	e3:SetOperation(c1200053.spop)
	c:RegisterEffect(e3)
	--SSet
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200053,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1200053.sstg)
	e3:SetOperation(c1200053.ssop)
	c:RegisterEffect(e3)
end
function c1200053.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c1200053.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c1200053.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c1200053.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function c1200053.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1200053.tpop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.SetLP(1-tp,4000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1200053.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbc) and c:IsAbleToGraveAsCost()
end
function c1200053.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200053.spcfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local cg=Duel.SelectMatchingCard(tp,c1200053.spcfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(cg,REASON_COST)
end
function c1200053.spfilter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1200053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200053.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_GRAVE)
end
function c1200053.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) or Duel.IsExistingMatchingCard(c1200053.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)) then return false end
	local sg=Duel.SelectMatchingCard(tp,c1200053.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if sg then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
function c1200053.ssfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfbc)
end
function c1200053.sssfilter(c)
	return c:IsSetCard(0xfbc) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c1200053.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200053.sssfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c1200053.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c1200053.sssfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end





