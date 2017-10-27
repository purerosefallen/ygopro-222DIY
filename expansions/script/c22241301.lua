--Solid Conversion
function c22241301.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,222413011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22241301.target)
	e1:SetOperation(c22241301.activate)
	c:RegisterEffect(e1)
	--Release-
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,222413012)
	e2:SetCondition(c22241301.adcon)
	e2:SetTarget(c22241301.adtg)
	e2:SetOperation(c22241301.adop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
c22241301.named_with_Solid=1
function c22241301.IsSolid(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Solid
end
function c22241301.valcheck(c,rc)
	local rlv=c:GetRitualLevel(rc)
	if c:IsHasEffect(EFFECT_RITUAL_LEVEL) and bit.band(rlv,0xf0000)~=0 and (bit.band(rlv,0xf0000)==rc:GetOriginalLevel()*0x10000 or bit.band(rlv,0xf)==rc:GetOriginalLevel()) then
		return bit.bor(rc:GetOriginalLevel()*2,c:GetOriginalLevel()*0x10000)
	else
		return rlv
	end
end
function c22241301.filter(c,e,tp,m1,m2,ft)
	if not c22241301.IsSolid(c) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(c22241301.valcheck,c:GetOriginalLevel()*2,1,99,c)
	else
		return ft>-1 and mg:IsExists(c22241301.mfilterf,1,nil,tp,mg,c)
	end
end
function c22241301.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(c22241301.valcheck,rc:GetOriginalLevel()*2,0,99,rc)
	else return false end
end
function c22241301.mfilter(c)
	return c22241301.IsSolid(c) and bit.band(c:GetType(),0x81)==0x81 and bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsAbleToDeck()
end
function c22241301.rfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsReleasableByEffect() and c:IsLocation(LOCATION_HAND)
end
function c22241301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp)
		local mg1=Duel.GetRitualMaterial(tp):Filter(c22241301.rfilter,nil)
		local mg2=Duel.GetMatchingGroup(c22241301.mfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c22241301.filter,tp,LOCATION_DECK,0,1,nil,e,tp,mg1,mg2,ft) and Duel.GetMZoneCount(tp)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22241301.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp):Filter(c22241301.rfilter,nil)
	local mg2=Duel.GetMatchingGroup(c22241301.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22241301.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,c22241301.valcheck,tc:GetOriginalLevel()*2,1,99,tc)
		end
		tc:SetMaterial(mat)
		g3=mat:Filter(Card.IsLocation,nil,LOCATION_HAND)
		g4=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		Duel.Release(g3,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.SendtoDeck(g4,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c22241301.spfilter(c,e,tp)
	return bit.band(c:GetType(),0x81)==0x81 and bit.band(c:GetReason(),REASON_RELEASE)~=0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c22241301.adcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return bit.band(e:GetHandler():GetReason(),REASON_RELEASE)~=0
end
function c22241301.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22241301.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	local g=Duel.SelectTarget(tp,c22241301.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE)
end
function c22241301.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	end
end