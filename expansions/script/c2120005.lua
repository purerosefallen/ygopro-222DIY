--铁血人形-破坏者
function c2120005.initial_effect(c)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c2120005.aclimit)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2120005,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c2120005.destg)
	e1:SetOperation(c2120005.desop)
	c:RegisterEffect(e1)
	--special summon
	--local e5=Effect.CreateEffect(c)
	--e5:SetDescription(aux.Stringid(2120005,1))
	--e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	--e5:SetCode(EVENT_TO_GRAVE)
	--e5:SetCountLimit(1,2120005)
	--e5:SetCondition(c2120005.spcon2)
	--e5:SetTarget(c2120005.sptg2)
	--e5:SetOperation(c2120005.spop2)
	--c:RegisterEffect(e5)
end
function c2120005.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and re:GetHandler():IsPosition(POS_FACEUP_ATTACK) and not re:GetHandler():IsImmuneToEffect(e)
end
function c2120005.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c2120005.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c2120005.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2120005.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c2120005.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c2120005.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c2120005.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c2120005.spfilter2(c,e,tp)
	return c:IsCode(2120000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2120005.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c2120005.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c2120005.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2120005.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end