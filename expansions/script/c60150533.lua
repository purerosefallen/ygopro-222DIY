--幻想乐章的交响曲
function c60150533.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c60150533.target)
	e1:SetOperation(c60150533.activate)
	c:RegisterEffect(e1)
end
function c60150533.spfilter(c,code,lv,e,tp)
	return c:IsSetCard(0xcb20) and c:GetRank()==lv and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150533.filter(c,e,tp)
	local lv=c:GetRank()
	return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c60150533.spfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetCode(),lv,e,tp)
end
function c60150533.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c60150533.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c60150533.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c60150533.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60150533.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local code=tc:GetCode()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lv=tc:GetRank()
	local g=Duel.SelectMatchingCard(tp,c60150533.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,code,lv,e,tp)
	local tc2=g:GetFirst()
	if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)>0 then
		e:GetHandler():CancelToGrave()
		Duel.Overlay(tc2,e:GetHandler())
	end
end