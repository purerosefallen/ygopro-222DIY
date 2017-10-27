--融合樱
local m=37564103
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x772),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c37564103.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c37564103.spcon1)
	e2:SetOperation(c37564103.spop1)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,37564103)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c37564103.discon)
	e3:SetTarget(c37564103.distg)
	e3:SetOperation(c37564103.disop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37564103,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	--e4:SetCondition(c37564103.condition)
	e4:SetTarget(c37564103.thtg)
	e4:SetOperation(c37564103.thop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c37564103.spcon)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c37564103.spfilter1(c,tp,fc)
	return c:IsSetCard(0x772) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c37564103.spfilter2,1,c,fc)
end
function c37564103.spfilter2(c,fc)
	return c:IsSetCard(0x772) and c:IsCanBeFusionMaterial(fc)
end
function c37564103.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c37564103.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>-2
		and Duel.CheckReleaseGroup(tp,c37564103.spfilter1,1,nil,tp,c)
end
function c37564103.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c37564103.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c37564103.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c37564103.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c37564103.filter(c,e,tp)
	return c:IsSetCard(0x772) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c37564103.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c37564103.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c37564103.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	local g=Duel.SelectTarget(tp,c37564103.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function c37564103.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local tc=Duel.GetFirstTarget()
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c37564103.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c37564103.tfilter(c,e,tp)
	return c:IsCode(37564104)
end
function c37564103.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c37564103.tfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c37564103.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 or Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37564103.tfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	   Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	   tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
function c37564103.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(37564103)>0
end