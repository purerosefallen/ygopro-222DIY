--口袋妖怪 卡蒂狗
function c80000258.initial_effect(c)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetValue(c80000258.splimit)
	c:RegisterEffect(e3)   
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80000258,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c80000258.spcon)
	e1:SetTarget(c80000258.sptg)
	e1:SetOperation(c80000258.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80000258,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c80000258.drcon)
	e4:SetTarget(c80000258.target)
	e4:SetOperation(c80000258.operation)
	c:RegisterEffect(e4)
end
function c80000258.splimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c80000258.spfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x2d0)
end
function c80000258.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80000258.spfilter,1,nil,tp)
end
function c80000258.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c80000258.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) 
		Duel.SpecialSummonComplete()
	end
end
function c80000258.filter(c)
	return c:IsSetCard(0x2d0) and not c:IsCode(80000258) and c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c80000258.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000258.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c80000258.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80000258.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.NegateAttack()
	end
end
function c80000258.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end