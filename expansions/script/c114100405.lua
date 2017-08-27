--皇子の強欲
function c114100405.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,114100405+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c114100405.target)
	e1:SetOperation(c114100405.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c114100405.handcon)
	c:RegisterEffect(e2)
end

function c114100405.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x221) and not c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c114100405.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c114100405.filter2(c,e,tp,mc)
	return c:IsRankBelow(6) and c:IsSetCard(0x226) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c114100405.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c114100405.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c114100405.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c114100405.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c114100405.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114100405.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		Duel.Overlay(sc,tc)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
	local matg=Duel.GetMatchingGroup(c114100405.matfilter,tp,LOCATION_GRAVE,0,nil)
	if matg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114100405,0)) then
		Duel.BreakEffect()
		local mattc=matg:Select(tp,1,99,nil)
		Duel.Overlay(sc,mattc)
	end
end
function c114100405.matfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end



function c114100405.hdfilter(c)
	return c:IsFaceup() and ( c:IsLevelAbove(5) or c:IsType(TYPE_XYZ) )
end
function c114100405.handcon(e)
	return Duel.IsExistingMatchingCard(c114100405.hdfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end