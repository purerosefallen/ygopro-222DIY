--幻想曲 极北的冻境
function c60150504.initial_effect(c)
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51126152,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c60150504.ntcon)
	c:RegisterEffect(e2)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95503687,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c60150504.spcost)
	e1:SetTarget(c60150504.sptg)
	e1:SetOperation(c60150504.spop)
	c:RegisterEffect(e1)
end
function c60150504.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c60150504.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60150504.filter(c,e,tp)
	return c:IsSetCard(0xab20) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150504.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c60150504.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60150504.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150504.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150504.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		--xyz limit
            local e4=Effect.CreateEffect(e:GetHandler())
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
            e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
            e4:SetValue(c60150504.xyzlimit)
            e4:SetReset(RESET_EVENT+0xfe0000)
            tc:RegisterEffect(e4)
            Duel.SpecialSummonComplete()
	end
end
function c60150504.xyzlimit(e,c)
    if not c then return false end
    return not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND))
end