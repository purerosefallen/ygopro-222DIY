--shenzhinu--
function c16063016.initial_effect(c)
	c:SetUniqueOnField(1,0,16063016)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(16063016)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c16063016.drcon)
	e4:SetTarget(c16063016.drtg)
	e4:SetOperation(c16063016.drop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c16063016.spcon)
	e5:SetTarget(c16063016.sptg)
	e5:SetOperation(c16063016.spop)
	c:RegisterEffect(e5)
end
function c16063016.cfilter(c,tp)
	return c:IsSetCard(0x5c5) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsType(TYPE_MONSTER)
end
function c16063016.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16063016.cfilter,1,nil,tp)
end
function c16063016.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c16063016.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c16063016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16063016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16063016.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16063016.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c16063016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c16063016.spfilter(c,e,tp)
	return c:IsCode(63008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16063016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c16063016.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16063016.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16063016.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end