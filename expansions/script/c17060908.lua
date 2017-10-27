--歌剧三妖精
function c17060908.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c17060908.linkfilter,3,3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060908,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17060908)
	e1:SetCost(c17060908.spcost)
	e1:SetTarget(c17060908.sptg)
	e1:SetOperation(c17060908.spop)
	c:RegisterEffect(e1)
end
c17060908.is_named_with_Opera_type=1
function c17060908.IsOpera_type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Opera_type
end
function c17060908.linkfilter(c)
	return c17060908.IsOpera_type(c)
end
function c17060908.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c17060908.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c17060908.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c17060908.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c17060908.filter(c,e,tp,m)
	if bit.band(c:GetOriginalType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c17060908.matfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function c17060908.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetMZoneCount(tp)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c17060908.matfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c17060908.filter,tp,LOCATION_PZONE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c17060908.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local mg=Duel.GetMatchingGroup(c17060908.matfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c17060908.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
