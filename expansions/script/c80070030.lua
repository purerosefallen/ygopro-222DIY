--蝴蝶之毒
function c80070030.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80070030+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c80070030.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c80070030.handcon)
	c:RegisterEffect(e2)  
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c80070030.damcon)
	e3:SetOperation(c80070030.damop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4) 
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80070030,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c80070030.spcon2)
	e5:SetTarget(c80070030.sptg)
	e5:SetOperation(c80070030.spop)
	c:RegisterEffect(e5)
end
function c80070030.filter(c,e,tp)
	return (c:IsSetCard(0x6a) or c:IsCode(16366944)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80070030.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c80070030.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80070030,0)) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80070030.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6a)
end
function c80070030.handcon(e)
	return Duel.IsExistingMatchingCard(c80070030.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80070030.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6a) and c:IsControler(tp)
end
function c80070030.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80070030.cfilter,1,nil,tp)
end
function c80070030.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,80070030)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c80070030.filter2(c,e,tp)
	return c:IsCode(16366944) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80070030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80070030.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c80070030.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80070030.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80070030.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end