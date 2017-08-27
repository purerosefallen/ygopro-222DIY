--加贺桑
function c99677714.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99677714,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,99677714+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(c99677714.spop)
	c:RegisterEffect(e1)
end
function c99677714.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x70e) and c:IsType(TYPE_MONSTER)
end
function c99677714.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end