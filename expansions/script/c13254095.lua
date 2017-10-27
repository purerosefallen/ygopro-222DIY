--升阶魔法-魔能之力
function c13254095.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254095,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c13254095.target)
	e1:SetOperation(c13254095.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,13254095+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c13254095.target1)
	e2:SetOperation(c13254095.activate1)
	c:RegisterEffect(e2)
	
end
function c13254095.filter1(c,e,tp)
	local lv=c:GetOriginalLevel()
	return c:IsFaceup() and c:IsSetCard(0x356) and c:IsType(TYPE_FUSION) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c13254095.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function c13254095.filter2(c,e,tp,lv)
	return (c:GetLevel()>=lv+1 and c:GetLevel()<=lv+4) and c:IsSetCard(0x356)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true)
end
function c13254095.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c13254095.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingTarget(c13254095.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c13254095.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13254095.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local lv=tc:GetOriginalLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13254095.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local sc=g:GetFirst()
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c13254095.filter1a(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x356)
		and Duel.IsExistingMatchingCard(c13254095.filter2a,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,c:GetRace(),c:GetAttribute(),c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c13254095.filter2a(c,e,tp,mc,rk,rc,att,code)
	if c:GetOriginalCode()==6165656 and code~=48995978 then return false end
	return c:GetRank()>=rk and c:GetRank()<=rk+2 and c:IsRace(rc) and c:IsAttribute(att) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c13254095.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c13254095.filter1a(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c13254095.filter1a,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c13254095.filter1a,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13254095.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13254095.filter2a,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetRace(),tc:GetAttribute(),tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
