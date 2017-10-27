--传颂之物 艾露露
function c16063006.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16063006,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16063006)
	e1:SetCost(c16063006.spcost)
	e1:SetTarget(c16063006.sptg)
	e1:SetOperation(c16063006.spop)
	c:RegisterEffect(e1)
	 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16063006,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,16063006)
	e2:SetCondition(c16063006.descon)
	e2:SetTarget(c16063006.destg)
	e2:SetOperation(c16063006.desop)
	c:RegisterEffect(e2)
end
function c16063006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c16063006.filter(c,e,tp)
	return c:IsSetCard(0x5c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16063006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingMatchingCard(c16063006.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16063006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16063006.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c16063006.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063006.desfilter(c)
	return  c:IsDestructable()
end
function  c16063006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and  c16063006.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16063006.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16063006.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function  c16063006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end