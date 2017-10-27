--奇迹糕点 水果拼盘
function c12000037.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1)
	e1:SetCost(c12000037.spcost)
	e1:SetTarget(c12000037.sptg)
	e1:SetOperation(c12000037.spop)
	c:RegisterEffect(e1)   
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c12000037.descon)
	c:RegisterEffect(e7)
end
function c12000037.filter(c)
	return c:IsSetCard(0xfbe)
end
function c12000037.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000037.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c12000037.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c12000037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12000037.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<=0 then return end
	if c:IsRelateToEffect(e) then
		local sp=Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c12000037.cfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0xfbe) and not c:IsType(TYPE_TOKEN)
end
function c12000037.descon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.IsExistingMatchingCard(c12000037.cfilter,tp,LOCATION_MZONE,0,1,nil)
end