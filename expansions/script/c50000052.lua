--圣诞节 奇犽
function c50000052.initial_effect(c)
	--添加二重属性
	aux.EnableDualAttribute(c)
	--检索
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(50000052,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,50000052)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c50000052.sptg)
	e1:SetOperation(c50000052.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x50c))
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCondition(aux.IsDualState)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e3)
end

function c50000052.filter(c,e,tp)
	return c:IsSetCard(0x50c) and not c:IsCode(50000052) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000052.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50000052.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c50000052.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50000052.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50000052.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		then	tc:EnableDualState()
	end
end