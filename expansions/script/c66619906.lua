--AIW·先知毛毛虫
function c66619906.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66619906,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c66619906.spcon1)
	e1:SetTarget(c66619906.target)
	e1:SetOperation(c66619906.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66619904,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c66619906.thtg)
	e4:SetOperation(c66619906.thop)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66619906,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_GRAVE)
	--e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(c66619906.con)
	e5:SetTarget(c66619906.target1)
	e5:SetOperation(c66619906.operation1)
	c:RegisterEffect(e5)
end
function c66619906.cfilter(c,tp)
	return c:IsCode(66619916) and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousControler()==tp
end
function c66619906.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66619906.cfilter,1,nil,tp)
end
function c66619906.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66619906.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c66619906.spfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66619906.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingMatchingCard(c66619906.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66619906.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66619906.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c66619906.gfilter(c,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c66619906.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66619906.gfilter,1,nil,tp)
end
function c66619906.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66619906.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end