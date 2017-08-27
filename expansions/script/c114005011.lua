--★変身魔女っ子　健一
function c114005011.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,114005011)
	e1:SetCost(c114005011.spcost)
	e1:SetTarget(c114005011.sptg)
	e1:SetOperation(c114005011.spop)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xab0)
	c:RegisterEffect(e2)
end
function c114005011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c114005011.otofilter(c)
	return c:IsSetCard(0xab0) or c:IsCode(21175632) or c:IsCode(68018709)
end
function c114005011.filter(c,e,tp)
	return ( c:IsSetCard(0x221) or c114005011.otofilter(c) ) and c:IsLevelBelow(4) --not 0x199
	and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c114005011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c114005011.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c114005011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c114005011.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if not tc then return end
	local spos=0
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
	Duel.SpecialSummon(tc,352,tp,tp,false,false,spos)
	if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end --confirm
	--if tc:GetLevel()>=5 then
	--	local e1=Effect.CreateEffect(c)
	--	e1:SetType(EFFECT_TYPE_SINGLE)
	--	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	--	e1:SetValue(1900)
	--	e1:SetReset(RESET_EVENT+0x1fe0000)
	--	tc:RegisterEffect(e1)
	--	local e2=e1:Clone()
	--	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	--	tc:RegisterEffect(e2)
	--end
end
